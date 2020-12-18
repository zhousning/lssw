# coding: utf-8

namespace :project do
  desc "project tasks"
  task :tasks do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    Rake::Task["db:add_permissions"].invoke
    Rake::Task["assets:precompile"].invoke
    Rake::Task["kindeditor:assets"].invoke
  end
end
