require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Contents' do
  header "Authorization", :authorization

  let!(:role) { create(:role) }
  let!(:user) { create(:user, roles: [role]) }
  let!(:content) { create(:content, :with_type_modulee) }
  let(:quiz_content) { build_quiz_hierarchy }
  let(:flashcard_content) { build_flashcard_hierarchy }
  let(:authorization) { token_generator(user.id) }

  get 'api/v1/contents/:id' do
    parameter :bookmarks, 'If flag is true and bookmarks are enabled for module, the response will contain all the bookmakrs for specific module (optional)'
    parameter :incorrect_questions, 'If flag is true and incorrect questions are enabled for module, the response will contain all the incorrect questions for specific module (optional)'
    let(:bookmarks) {true}
    let(:incorrect_questions) {true}
    example 'Get a module content' do
      explanation "Use this endpoint to get a module type content against the given ID"
      
      do_request(id: quiz_content.parent.id)
      expect(status).to eq(200)
    end
  end

  get 'api/v1/contents/:id' do
    example 'Get a chapter content' do
      explanation "Use this endpoint to get a chapter [Quiz, Flashcard, Html, Media] type content against the given ID"
      
      do_request(id: quiz_content.id)
      expect(status).to eq(200)
    end
  end

  get 'api/v1/contents/:id/chapters' do
    example 'Get all chapters' do
      explanation "Use this endpoint to get all chapters for a module content ID"
      do_request(id: quiz_content.parent.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  get 'api/v1/contents/:id/exams' do
    example 'Get all exams' do
      explanation "Use this endpoint to get all exams for a module content ID"
      
      do_request(id: quiz_content.parent.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  get 'api/v1/contents/:id/questions' do
    example 'Get all questions' do
      explanation "Use this endpoint to get all questions for a module content ID"
      
      do_request(id: quiz_content.parent.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  get 'api/v1/contents/:id/build_quiz' do
    parameter :chapter_ids, "IDs for selected chapters to build a quiz"
    parameter :no_of_questions, "No of questions. The number is limited to following values: 25, 50, 100 or All"
    
    let(:chapter_ids) { [quiz_content.id] }
    let(:no_of_questions) { "25" }
    example 'Build a quiz' do
      explanation "Use this endpoint to create a new build quiz"
      do_request(id: quiz_content.parent.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end
  
  get 'api/v1/contents/:id/get_build_quiz' do
    example 'Get build quizzes' do
      explanation "Use this endpoint to build test of type quiz against the content ID of actable type module"
      do_request(id: quiz_content.parent.id)
      
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  get 'api/v1/contents/:id/build_flashcard' do
    parameter :chapter_ids, "IDs for selected chapters to build a flashcard"
    parameter :no_of_flashcards, "No of flashcard items. The number is limited to following values: 25, 50, 100 or All"
    
    let(:chapter_ids) { [flashcard_content.id] }
    let(:no_of_flashcards) { "25" }
    example 'Build flashcards' do
      explanation "Use this endpoint to create a new build flashcard"
      do_request(id: flashcard_content.parent.id)
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end
  
  get 'api/v1/contents/:id/get_build_flashcard' do
    example 'Get build a flashcard' do
      explanation "Use this endpoint to get build test of type flashcard against the content ID of actable type module"
      do_request(id: flashcard_content.parent.id)
      
      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end

  get 'api/v1/contents/:id/bookmark' do
    parameter :content_type_id, 'The id of question or flashcard item'
    parameter :content_type, "The type for the item i.e 'Question' or 'FlashcardItem' "
    parameter :destroy, "(Optional) If true, the request will consider for unbookmark. If not given, the request will consider for bookmark the item"
    let(:content_type_id) {quiz_content.specific.items.first.id}
    let(:content_type) {'Question'}
    
    example 'Bookmark' do
      explanation "Use this endpoint to bookmark or unbookmark flashcard item or question aginst chapter id and question/flahscard id. Returns the updated array of ids of bookmarked items"
      do_request(id: quiz_content.id)

      expect(status).to eq(200)
      expect(JSON.parse(response_body)["success"]).to eq(true)
    end
  end
end
