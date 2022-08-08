require 'venice'

class API::V1::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :contents, :subscribe, :app_store_subscription, :exams, :questions]
  before_action :authorize_request, only: [:contents, :subscribe, :app_store_subscription, :exams, :questions]

  include ContentsHelper

  def index
    @products = Product.all
    json_response(@products)
  end

  def show

    authorize_request
    rescue StandardError => e
      p e.message
    ensure
      create_auto_subscription
      product = OpenStruct.new()
      product = get_product_attributes ActiveModelSerializers::SerializableResource.new(@product).as_json, product
      is_subscribed = (@current_user.present? and @product.present?) ? UserSubscription.subscription_current?(@current_user, @product) : false
      product[:is_subscribed] =  is_subscribed
      if is_subscribed
        modules = []
        @product.contents.roots.each { |mod| modules.push({ module: mod, image: mod.image('square'), specific: (get_module_configurations mod), type: (modulee_type mod) }) }
        product[:modules] = modules  
      else
        modulees = get_auditable_modulees @product
        product[:auditable_modules] = modulees if modulees.present?
      end
      json_response({success: true, product: product, user: @current_user})

  end

  def contents
    json_response(@product.contents)
  end

  def subscribe
    success = false
    if params # and params[:charge].present?
      if params["customer"].present?
        @current_user.stripe_customer_id = params["customer"];
        @current_user.save!
      end

      sub = UserSubscription.find_or_create_by(user: @current_user, product: @product)
      success = sub.save! ? true : false

      render json: {success: success}  
    else
      render json: { success: false, message: 'Error while creating subscription!' }
    end
  end

  def app_store_subscription
    if params and params[:receipt_data] and params[:transaction_id].present?
      # Verify receipt data before subscription
      # @Reminder: Shared key is required for auto-reknowable
      if receipt = Venice::Receipt.verify(params[:receipt_data])
        # token: currently used to keep receipt data (in case of iOS)
        sub = UserSubscription.find_or_create_by(user: @current_user, product: @product, token: params[:receipt_data], transaction_id: params[:transaction_id], sub_start: Time.now)

        sub ? json_response({success: true, message: 'Subscription created successfully.'}) : json_response({success: false, message: 'Error while creating subscription!'})
      else
        json_response({success: false, message: "Invalid receipt data. Couldn\'t subscribe the product. Please try again"})
      end
    else
      render json: { success: false, message: 'Missing parameters to verify purchase!' }
    end
  end

  def exams
    raise(ExceptionHandler::UnprocessableEntity, "Product doesn't exist") if @product.blank?
    @contents = @product.contents.where(actable_type: 'Modulee')
    contents = [] 
    @contents.each do |content|
      contents.push(get_exams_for_module_content content, @current_user)
    end
    contents = contents.flatten if contents.present?
    render json: {success: true, exams: contents}
  end

  def questions
    raise(ExceptionHandler::UnprocessableEntity, "Product doesn't exists") if @product.blank?
    questions = []
    @contents = @product.contents.where(actable_type: 'Modulee')
    @contents.each do |content|
      content.children.where(actable_type: "Quiz").each do |quiz|
        questions.push(quiz.specific.items)
      end
    end
    
    questions = questions.flatten
    render json: {success: true, questions: questions}
  end

  private

  def get_product_attributes serialized_product, product
    if serialized_product.present? 
      serialized_product.each do |key, value|
        product[key.to_sym] = value 
      end
    end
  end

  def set_product
    @product = Product.friendly.find(params[:id]) if params[:id].present?
  end

  def create_auto_subscription
    if(@product.price <= 0 and @current_user.present?)
      sub = UserSubscription.find_or_create_by(user: @current_user, product: @product)
      sub.save!
    end
  end

  def auditable_module? content
    return if content.blank?
    mod = content.specific
    mod = get_module_configurations content
    return (mod[:configurations].present? and mod[:configurations][:auditable].present?)
  end

  def get_auditable_limit content, actable
    return if content.blank? or actable.blank?
    mod = content.specific
    limit = 20
    if (mod.configurations.present? and mod.configurations[:auditable])
      limit = mod.configurations[:"auditable_#{actable}_limit"].to_i if mod.configurations[:"auditable_#{actable}_limit"].present?
    end
    limit
  end

  def get_auditable_modulees product
    modulees = []
    @product.contents.roots.each do |content|
      if auditable_module? content
        if isTypeQuiz? content
          limit = get_auditable_limit content, 'questions'
          modulees.push({ module: content, image: content.image('square'), type: (modulee_type content), auditable_content_types: (get_auditable_questions content, limit) })
        elsif isTypeFlashcard? content
          limit = get_auditable_limit content, 'flashcards'
          modulees.push({ module: content, image: content.image('square'), type: (modulee_type content), auditable_content_types: (get_auditable_flashcards content, limit) })
        elsif isTypeMedia? content
          modulees.push({ module: content, image: content.image('square'), type: (modulee_type content), auditable_content_types: (get_auditable_media content) })
        end
      end
    end
    return modulees
  end
end