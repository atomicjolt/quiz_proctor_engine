$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "quiz_proctor_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "quiz_proctor_engine"
  s.version     = QuizProctorEngine::VERSION
  s.authors     = ["dittonjs"]
  s.email       = ["jditton.atomic@gmail.com"]
  s.homepage    = ""
  s.summary     = "Allows students to take canvas quizzes in a chromeless view, as well as allow proctors to enter answers on behalf of a student"
  s.description = "Allows students to take canvas quizzes in a chromeless view, as well as allow proctors to enter answers on behalf of a student"
  s.license     = "AGPL-3.0"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.2", "< 5.1"
end
