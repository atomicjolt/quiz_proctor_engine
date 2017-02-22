module QuizProctorEngine
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path(File.join(__FILE__, "../.."))

    config.to_prepare do
      Canvas::Plugin.register(
        :quiz_proctor,
        nil,
        name: -> { I18n.t(:quiz_proctor_name, "Quiz Proctor") },
        display_name: -> { I18n.t :quiz_proctor_display, "Quiz Proctor" },
        author: "Atomic Jolt",
        author_website: "http://www.atomicjolt.com/",
        description: -> { t(:description, "Enable taking proctored quizzes in a chromeless view") },
        version: QuizProctorEngine::VERSION,
        settings_partial: "quiz_proctor_engine/plugin_settings",
      )
    end
  end
end
