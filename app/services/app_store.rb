require 'spaceship'
class AppStore < StandardError
  @error = ''

  def initialize
    @spaceship_user = Spaceship::Tunes.login(ENV['APP_STORE_USERNAME'], ENV['APP_STORE_PASSWORD'])
    Spaceship::Tunes.select_team  # Declare 'FASTLANE_ITC_TEAM_ID' env variable to automate team selection.
    rescue Spaceship::InvalidUserCredentialsError => e
      set_error e.message
      return false
    rescue Spaceship::Tunes::Error => e
      set_error e.message
      return false
    rescue StandardError => e
      set_error e.message
      return false
  end
  
  def find_app app_id
    raise "Required App Id is missing." if app_id.nil?
    resp = OpenStruct.new
    app = Spaceship::Tunes::Application.find(app_id)
    raise "No App found with id: #{app_id}" if app.nil?
    resp[:app_id] = app.apple_id
    resp[:name] = app.name
    resp[:vendor_id] = app.vendor_id
    resp[:bundle_id] = app.bundle_id
    resp[:iaps] = app.in_app_purchases.all.collect{ |p| { reference_name: p.reference_name, product_id: p.product_id, tier: p.edit.pricing_intervals.first[:tier] }} if app.in_app_purchases.present?
    resp.marshal_dump
    # app
    rescue StandardError => e
      set_error e.message
      return false
  end

  def find_bundle apple_id
    raise "Required App Id is missing." if apple_id.nil?
    resp = OpenStruct.new
    app = Spaceship::Tunes.client.bundle_details(apple_id)
    raise "No Bundle found with id: #{apple_id}" if app.nil?
    resp[:name] = app["details"].first["name"]
    resp[:adam_id] = app["adamId"]
    resp[:vendor_id] = app["vendorIdentifier"]
    resp[:tier] = app["priceTierStem"]
    resp.marshal_dump
    rescue StandardError => e
      set_error e.message
      return false
  end
  
  def create_app params
    raise "Required paraments are missing." if params.blank?
    Spaceship::Tunes::Application.create!(
      name: params[:app_name],
      primary_language: "English",
      version: params[:version],
      sku: params[:sku],
      bundle_id: params[:app_store_bundle_id]
    )
    set_error nil
    return find_app params[:app_store_bundle_id]
    rescue Spaceship::Tunes::Error => e
      set_error e.message
      return false
    rescue StandardError => e
      set_error e.message
      return false
  end

  def create_iap params, app_id, type=nil
    raise "Required paraments are missing." if params.blank?
    @app = Spaceship::Tunes::Application.find(app_id)
    raise "App not found." if @app.nil?
    obj = {
      type: Spaceship::Tunes::IAPType::NON_CONSUMABLE,
      versions: {
        "en-US" => {
          name: params[:reference_name],
          description: params[:description],
        },
      },
      reference_name: params[:reference_name],
      product_id: params[:iap_id],
      cleared_for_sale: params[:cleared_for_sale] == "1",
      review_notes: "A note for a reviewer",
      review_screenshot: "#{Rails.root.join('public', 'images', 'review_screenshot.png')}", 
      pricing_intervals: 
      [
        {
          country: "WW",
          begin_date: nil,
          end_date: nil,
          tier: params[:price].to_i
        }
      ]
    }
    @app.in_app_purchases.create!(obj)
    set_error nil     # api raises exceptions if something went wrong and returns nil is all gone well. (based on observation)
    return true 
    rescue Spaceship::Tunes::Error => e
      set_error e.message
      return false
    rescue StandardError => e
      set_error e.message
      return false
  end

  def find_iap product_id, app_id
    raise "Product Id not found." if product_id.nil?
    @app = Spaceship::Tunes::Application.find(app_id)
    raise "App not found." if @app.nil?
    return @app.in_app_purchases.find(product_id)
    rescue StandardError => e
      set_error e.message
      return false 
  end
    
  def update_iap params, app_id
    raise "Required paraments are missing." if params.blank?
    @app = Spaceship::Tunes::Application.find(app_id)
    raise "App not found." if @app.nil?
    purchase = @app.in_app_purchases.find(params[:iap_id])    # return nil if iap not found. (Contrary to the 'nil' returned after successfull process) 
    raise "AppStore not found for given id: '#{params[:iap_id]}'." if purchase.nil?
    purchase = purchase.edit
    purchase.versions = {
      'en-US': {
        name: params[:reference_name]
      }
    } 

    purchase.pricing_intervals = [
      {
        country: "WW",
        begin_date: nil,
        end_date: nil,
        tier: params[:price]
      }
    ] 
    purchase.save!

    set_error nil     # api raises exceptions if something went wrong and returns nil is all gone well. (based on observation)
    return true 
    rescue Spaceship::Tunes::Error => e
      set_error e.message
      return false
    rescue StandardError => e
      set_error e.message
      return false
    
  end

  def delete_iap product_id, app_id
    raise "App Id not found." if app_id.nil?
    raise "Product Id not found." if product_id.nil?
    @app = Spaceship::Tunes::Application.find(app_id)
    purchase = @app.in_app_purchases.find(product_id)
    purchase.delete!
    set_error nil
    return true
    rescue StandardError => e
      set_error e.message
      return false
  end
  
  def errors
    return @error
  end
end

private 

def set_error error=nil
  @error = error
end
