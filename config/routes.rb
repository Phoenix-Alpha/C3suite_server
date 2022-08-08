Rails.application.routes.draw do

  # API
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :products do
        member do
          get 'contents'
          get 'subscribe'
          get 'app_store_subscription'
          get 'exams'
          get 'questions'
        end
      end

      resources :bundles do
        member do
          get 'contents'
          get 'subscribe'
        end
      end

      resources :contents do
        member do
          get 'chapters'
          get 'exams'
          get 'questions'
          get 'bookmark'
          get 'viewed_contents'
          get 'modulee_bookmarks'
          get 'quiz_attempts'
          get 'results'
          get 'result'
          get 'comprehensiveQuiz'
          get 'comprehensiveFlashcard'
          get 'startover'
          get 'build_quiz'
          get 'get_build_quiz'
          get 'build_flashcard'
          get 'get_build_flashcard'
        end
      end

      resources :users, only: [:create]
      get 'users/forgot_password', to: 'users#forgot_password'  
      post 'users/token', to: 'users#token'
      post 'users/change_password', to: 'users#change_password'
      post 'users/change_email', to: 'users#change_email'
      post 'users/reset_password', to: 'users#reset_password'
    end
  end

  # Manage
  namespace :manage do
      resources :users do
        member do
          get 'get_user_roles'
        end
      end

      resources :bundles do
        get 'app_store'
        get 'edit_iap'
        post 'create_app'
        post 'create_iap'
        put 'update_iap'
        delete 'delete_iap'

        resources :bundle_assets, path: 'assets'
      end

      resources :products

      resources :products do
        post 'import'
        get 'app_store'
        get 'edit_iap'
        post 'create_app'
        post 'create_iap'
        put 'update_iap'
        delete 'delete_iap'
        
        member do
          get :contents
          get :permissions, only: [:index]
        end

        resources :modulees, path: 'modules' do
          member do
            get 'comprehensive_quiz'
            get 'skippable_quizzes'
            post 'comprehensive_quiz_submit'
          end
        end  
        resources :submodules, path: 'submodules'

        resources :flashcards do
          member do
            get 'update_flashcard_item_position'
            get 'update_flashcard_labels'
            get 'flashcards_setting'
          end

          collection do
            get 'upload'
          end
        end
        resources :htmls, path: 'html' do
          collection do
            get 'upload'
          end
        end
        resources :quizzes do
          get 'download'

          collection do
            get 'upload'
          end
        end
        resources :media

        resources :product_assets, path: 'assets'
      end

      resources :tags

      resources :contents do
        resources :content_assets, path: 'content_assets'

        collection do
          get 'update_content_position'
        end

      end

      resources :roles, only: [:show]
  end

  resources :bundles, only: [:show] do
    member do
      post 'subscribe'
    end
  end

  resources :products, only: [:show] do
    member do
      get 'create_checkout_session'
      get 'subscription_success'
      get 'subscription_failed'
    end
  end

  resources :bookmarks, only: [:index, :show] do
    member do
    end  
  end

  resources :contents, only: [:show] do
    member do
      get 'show_build_a_quiz'
      get 'show_build_a_flashcard'
    end
  end

  resources :quizzes do
    collection do
      get 'comprehensive'
      get 'comprehensive/viewedcontent', to: 'quizzes#comp_viewedcontent'
      get 'comprehensive/instructions', to: 'quizzes#instructions_for_comprehensive'
      get 'comprehensive/results', to: 'quizzes#results_for_comprehensive'
      get 'comprehensive/result', to: 'quizzes#result_for_comprehensive'
      get 'comprehensive/startover', to: 'quizzes#startover_for_comprehensive'
      get 'build', to: 'quizzes#build_quiz'
      get 'build/viewedcontent', to: 'quizzes#build_viewedcontent'
      get 'build/results', to: 'quizzes#results_for_build'
      get 'build/result', to: 'quizzes#result_for_build'
      get 'bookmark', to: 'quizzes#bookmark'
      get 'incorrect/index', to: 'quizzes#incorrect_listing'
      get 'incorrect', to: 'quizzes#quiz_for_incorrect'
      get 'instructions/incorrect', to: 'quizzes#instructions_for_incorrect'
      get 'incorrect/viewedcontent', to: 'quizzes#incorrect_viewedcontent'
      get 'incorrect/results', to: 'quizzes#results_for_incorrect'
      get 'incorrect/result', to: 'quizzes#result_for_incorrect'
    end

    member do
      get 'audit'
      get 'instructions'
      post 'build'
      get 'study'
      get 'exam'
      get 'exam/startover', to: 'quizzes#startover'
      get 'exam/viewedcontent', to: 'quizzes#viewedcontent'
      get 'results', to: 'quizzes#results'
      get 'result/:attempt_id', to: 'quizzes#result', as: 'result'
    end
  end

  resources :flashcards do
    member do
      get 'audit'
    end

    collection do
      get 'comprehensive'
      get 'comprehensive/viewedcontent', to: 'flashcards#comp_viewedcontent'
      get 'build/viewedcontent', to: 'flashcards#build_viewedcontent'
      post 'build'
      get 'build', to: 'flashcards#build_continue'
      get 'startover'
      get 'bookmark', to: 'flashcards#bookmark'
    end

    member do
      get 'viewedcontent'
      get 'startover'
    end
  end

  resources :media do
    member do
      get 'bookmark'
      get 'viewedcontent'
    end  
  end
  resources :htmls do
    member do
      get 'bookmark'
      get 'viewedcontent'
    end
  end

  resources :bookmarks, only: [:index, :show]
  resources :viewedcontents, only: [:index]

  # Devise
  devise_for :users, :controllers => { registrations: 'users/registrations' }

  authenticated :user do
    mount DelayedJobWeb, at: "/delayed_job"
  end

  root 'dashboard#index'

  # User dashboard
  get '/dashboard', to: 'dashboard#index'
  get '/purchases', to: 'dashboard#purchases'

  get '/manage', to: 'manage/users#index'

  # Pages
  get 'page/home'
  get 'page/about'
  get 'page/contact'

  # Diagnostics
  get 'healthcheck', to: 'diagnostics#healthcheck'

end
