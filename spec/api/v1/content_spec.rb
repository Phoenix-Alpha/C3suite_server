require 'rails_helper'

RSpec.describe 'API/v1 contents', type: :request do
	let!(:role) { create(:role) }
  	let!(:user) { create(:user, roles: [role]) }
	let!(:quiz_content) { build_quiz_hierarchy }
	let!(:flashcard_content) { build_flashcard_hierarchy }
	let(:headers) { valid_headers }

	# describe 'GET /contents/chapters' do
	# 	context "when valid module content id is sent" do
	# 		before { get chapters_api_v1_content_path(id: quiz_content.parent.id), headers: headers }
			
	# 		it "returns all chapters for that module" do
	# 			expect(response).to have_http_status(:ok)
	# 			expect(JSON.parse(response.body)["success"]).to eq(true)
	# 		end
	# 	end

	# 	context "when invalid module content id is sent" do
	# 		before { get exams_api_v1_content_path(id: quiz_content.id), headers: headers }
			
	# 		it "returns unprocessable entity status" do
	# 			expect(response).to have_http_status(:unprocessable_entity)
	# 		end
	# 	end
	# end

	# describe 'GET /contents/exams' do
	# 	context "when valid module content id is sent" do
	# 		before { get exams_api_v1_content_path(id: quiz_content.parent.id), headers: headers }
			
	# 		it "returns attempts and questions for that module" do
	# 			expect(response).to have_http_status(:ok)
	# 			expect(JSON.parse(response.body)["success"]).to eq(true)
	# 		end
	# 	end

	# 	context "when invalid module content id is sent" do
	# 		before { get exams_api_v1_content_path(id: quiz_content.id), headers: headers }
			
	# 		it "returns unprocessable entity status" do
	# 			expect(response).to have_http_status(:unprocessable_entity)
	# 		end
	# 	end
	# end

	describe 'GET /contents/show' do
		context "when content id for module given" do
			before { get api_v1_content_path(id: quiz_content.parent.id), headers: headers }
			it "returns chapters" do
				expect(response).to have_http_status(:ok)
			end
		end

		context "when content id for module given with additional parameter bookmarks" do
			before { get api_v1_content_path(id: quiz_content.parent.id), params: {bookmarks: true}, headers: headers }
			it "returns chapters and bookmarks if bookmarks are enabled from configurations" do
				expect(response).to have_http_status(:ok)
				expect(JSON.parse(response.body)["contents"]["bookmarks"].nil?).to eq(false)
			end
		end

		context "when content id for module given with additional parameter incorrect_questions" do
			before { get api_v1_content_path(id: quiz_content.parent.id), params: {incorrect_questions: true}, headers: headers }
			it "returns chapters and incorrect_questions if incorrect_questions are enabled from configurations" do
				expect(response).to have_http_status(:ok)
				expect(JSON.parse(response.body)["contents"]["incorrect_questions"].nil?).to eq(false)
			end
		end

		context "when content id for module given" do
			before { get api_v1_content_path(id: quiz_content.parent.id), headers: headers }

			it "returns chapters" do
				expect(response).to have_http_status(:ok)
			end
		end

		context "when content id for quiz given" do
		end
		context "when content id for flashcard given" do
		end
		context "when content id for module given" do
		end
		context "when content id for module given" do
		end
	end

	# describe 'GET /contents/build_quiz' do
	# 	context "when valid no. of questions and chapter ids are sent" do
	# 		before { get build_quiz_api_v1_content_path(id: quiz_content.parent.id), params: { chapter_ids: [quiz_content.id], no_of_questions: "25" }, headers: headers }
	# 		it "creates build test records of type Quiz and returns all the questions." do
	# 			expect(response).to have_http_status(:ok)
	# 			expect(JSON.parse(response.body)["success"]).to eq(true)
	# 		end
	# 	end

	# 	context "when invalid chapter ids are sent as valid parameters" do
	# 		before { get build_quiz_api_v1_content_path(id: quiz_content.parent.id), params: { chapter_ids: [flashcard_content.id], no_of_questions: "25" }, headers: headers }
	# 		it "returns record not found status" do
	# 			expect(response).to have_http_status(:not_found)
	# 		end
	# 	end
		
	# 	context "when invalid params are sent" do
	# 		before { get build_quiz_api_v1_content_path(id: quiz_content.parent.id), params: { faulty_ids: [quiz_content.id], no_of_flashcards: "25", extra_param: "asd" }, headers: headers }
	# 		it "returns bad request error" do
	# 			expect(response).to have_http_status(:bad_request)
	# 		end
	# 	end
	# end

	# describe 'GET /contents/get_build_quiz' do
	# 	before { get get_build_quiz_api_v1_content_path(id: quiz_content.parent.id), headers: headers }
	# 	it "returns questions, viewed items and previous results of type build quiz against specific module" do
	# 		expect(response).to have_http_status(:ok)
	# 		expect(JSON.parse(response.body)["success"]).to eq(true)
	# 	end
	# end

	# describe 'GET /contents/build_flascard' do
	# 	context "when valid no. of flashcards and chapter ids are sent" do
	# 		before { get build_flashcard_api_v1_content_path(id: flashcard_content.parent.id), params: { chapter_ids: [flashcard_content.id], no_of_flashcards: "25" }, headers: headers }
	# 		it "creates build test records of type Flashcard and returns all the flashcard items." do
	# 			expect(response).to have_http_status(:ok)
	# 			expect(JSON.parse(response.body)["success"]).to eq(true)
	# 		end
	# 	end

	# 	context "when invalid params are sent" do
	# 		before { get build_flashcard_api_v1_content_path(id: flashcard_content.parent.id), params: { faulty_ids: [flashcard_content.id], no_of_flashcards: "25", extra_param: "asd" }, headers: headers }
	# 		it "returns bad request error" do
	# 			expect(response).to have_http_status(:bad_request)
	# 		end
	# 	end

	# 	context "when invalid chapter ids are sent as valid parameters" do
	# 		before { get build_flashcard_api_v1_content_path(id: flashcard_content.parent.id), params: { chapter_ids: [quiz_content.id], no_of_flashcards: "25" }, headers: headers }
	# 		it "returns record not found status" do
	# 			expect(response).to have_http_status(:not_found)
	# 		end
	# 	end

	# 	context "when content in of invalid type i.e Quiz" do
	# 		before { get build_flashcard_api_v1_content_path(id: quiz_content.parent.id), params: { chapter_ids: [flashcard_content.id], no_of_flashcards: "25" }, headers: headers }
	# 		it "returns bad request status" do
	# 			expect(response).to have_http_status(:bad_request)
	# 		end
	# 	end
	# end

	# describe 'GET /contents/get_build_flashcard' do
	# 	before { get get_build_flashcard_api_v1_content_path(id: flashcard_content.parent.id), headers: headers }
	# 	it "returns flashcard items and viewed items type build flashcard against specific module" do
	# 		expect(response).to have_http_status(:ok)
	# 		expect(JSON.parse(response.body)["success"]).to eq(true)
	# 	end
	# end
end