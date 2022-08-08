module ControllerSpecHelper
  # generate tokens from user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # generate expired tokens from user id
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  def generate_reset_token user
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    @token = raw
    user.reset_password_token = hashed
    user.reset_password_sent_at = Time.now.utc
    user.save
    raw
  end

  # return valid headers
  def valid_headers
    {

        "Authorization" => token_generator(user.id),
        "Content-Type" => "application/json"
    }
  end

  # return invalid headers
  def invalid_headers
    {
        "Authorization" => nil,
        "Content-Type" => "application/json"
    }
  end

  # def build_modules
  #   FactoryBot.create(:product)
  # end

  def build_quiz_hierarchy
    FactoryBot.create(:content, :with_type_quiz) do |content|
      cids = get_content_type_ids content
      cids.keys.each do |id|
        b = FactoryBot.create(:bookmark, user: user, content_type_id: id, content: content)
        b.content_type = 'Question'
        b.save!
        FactoryBot.create(:incorrect_question, content_type_id: id, user: user, content: content)
      end
      FactoryBot.create_list(:viewed_content, 3, user: user, content_type: 'Question', content_type_id: cids, completed: false, content: content) #chapter specific
      FactoryBot.create_list(:viewed_content, 3, user: user, content_type: 'Question', content_type_id: cids, completed: true, content: content) #chapter specific
      
      FactoryBot.create_list(:viewed_content, 3, user: user, content_type: 'BuildQuiz', content_type_id: cids, completed: false, content: content.parent)
      FactoryBot.create_list(:viewed_content, 3, user: user, content_type: 'BuildQuiz', content_type_id: cids, completed: true, content: content.parent)
      
      FactoryBot.create(:build_test, user: user, content: content.parent, chapter_ids: [content.id], content_type: 'Quiz')
    end
  end

  def build_flashcard_hierarchy
    FactoryBot.create(:content, :with_type_flashcard) do |content|
      cids = get_content_type_ids content
      cids.keys.each do |id|
        b = FactoryBot.create(:bookmark, user: user, content_type_id: id, content: content)
        b.content_type = 'FlashcardItem'
        b.save!
      end
      FactoryBot.create_list(:viewed_content, 3, user: user, content_type: 'Flashcard', content_type_id: cids, completed: false, content: content) #chapter specific
      FactoryBot.create_list(:viewed_content, 3, user: user, content_type: 'Flashcard', content_type_id: cids, completed: true, content: content) #chapter specific
      
      FactoryBot.create_list(:viewed_content, 3, user: user, content_type: 'BuildFlashcard', content_type_id: cids, completed: false, content: content.parent)
      FactoryBot.create_list(:viewed_content, 3, user: user, content_type: 'BuildFlashcard', content_type_id: cids, completed: true, content: content.parent)
      
      FactoryBot.create(:build_test, user: user, content: content.parent, chapter_ids: [content.id], content_type: 'Flashcard')
    end
  end
  
  def get_content_type_ids content
    content_type_ids = {}
    content.specific.items.first(3).pluck(:id).each_with_index do |q|
      content_type_ids[q.to_s] = {:selected => Faker::Number.between(from: 0, to: 3), :order => "0123"}
    end
    content_type_ids
  end
end