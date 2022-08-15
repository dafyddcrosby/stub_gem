#!/usr/bin/env ruby
# frozen_string_literal: true

require "pathname"
require "fileutils"
require "date"
require "erb"

module StubGem
  class RubyProject
    def initialize(project_name, base_path)
      @year = Date.today.year
      @author = "David Crosby"
      @project_name = project_name
      @project_class = @project_name.capitalize

      puts "* Using #{base_path}"
      @template_dir = "#{File.dirname(Pathname.new(__FILE__).realpath)}/../templates/"
      puts "* Template dir of #{@template_dir}"
      fail_usage "project folder location exists at #{base_path}" if Dir.exist? base_path
      @base_path_str = base_path
      stub_project
    end

    def project_class
      @project_class ||= @project_name.capitalize
    end

    def stub_project
      Dir.mkdir @base_path_str
      dir = Dir.new @base_path_str
      @base_path = "#{dir.path}/"
      puts "* Base path of: #{@base_path}"

      stub_directory_structure
      stub_project_docs
      stub_library_mgmt
      stub_testing
      stub_build_infra
      stub_linters
      stub_code_boilerplate
      stub_version_control
    end

    def stub_directory_structure
      [
        "lib/#{@project_name}",
        ".github/workflows",
        ".bundle",
        "bin",
        "test"
      ].each do |dir|
        FileUtils.mkdir_p("#{@base_path}/#{dir}")
      end
    end

    def stub_project_docs
      # TODO: stub_contributors
      %w[
        CODE_OF_CONDUCT.md
        README.md
        TODO.md
        LICENSE
      ].each do |f|
        stub_single_file(f)
      end
    end

    def stub_testing
      # TODO: stub_minitest
    end

    def stub_library_mgmt
      %w[
        Gemfile
      ].each do |f|
        stub_single_file(f)
      end
      [
        ["Gemfile"],
        ["gemspec", nil, "#{@project_name}.gemspec"]
      ].each do |name, dir, desired_name|
        stub_single_file name, dir, desired_name
      end
    end

    def stub_build_infra
      [
        ["Rakefile"],
        ["Guardfile"],
        ["bundle_config", ".bundle", "config"]
      ].each do |name, dir, desired_name|
        stub_single_file name, dir, desired_name
      end
    end

    def stub_linters
      %w[
        .rubocop.yml
      ].each do |f|
        stub_single_file(f)
      end
    end

    def stub_code_boilerplate
      [
        ["base_lib.rb.erb", "lib", "#{@project_name}.rb"],
        ["version.rb.erb", "lib/#{@project_name}", "version.rb"]
      ].each do |name, dir, desired_name|
        stub_single_file name, dir, desired_name
      end
    end

    def stub_version_control
      [
        [".gitignore"],
        ["ruby_gh_workflow.yml", ".github/workflows", "main.yml"]
      ].each do |name, dir, desired_name|
        stub_single_file name, dir, desired_name
      end
      # TODO: stub_gitcommit
      # TODO stub_github_project_templates
    end

    def stub_single_file(name, dir = nil, desired_name = nil)
      template = ERB.new(File.read(File.join(@template_dir, name)))
      desired_name ||= name
      filepath = "#{@base_path}/"
      filepath << "#{dir}/" if dir
      filepath << desired_name
      f = File.new(filepath, "w")
      f.write(template.result(binding))
      f.close
    end
  end
end
