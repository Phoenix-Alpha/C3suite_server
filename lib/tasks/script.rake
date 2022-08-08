namespace :script do 
    desc "Move modulee configurationss to configuration field"
    task :modulee_configurations => [:environment] do
        modulee = Modulee.all
        modulee.each do |mod|
            mod.configurations = {
                auditable: mod.auditable,
                has_bookmarks: mod.has_bookmarks,
                allow_comprehensive_quizzes: mod.allow_comprehensive_quizzes,
                allow_comprehensive_flashcards: mod.allow_comprehensive_flashcards,
                time_limit: mod.time_limit,
                comprehensive_questions: mod.comprehensive_questions,
                setting_skip_quiz: mod.setting_skip_quiz,
              
            }
            mod.save
        end
        
    end
    

end