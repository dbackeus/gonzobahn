# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{newrelic_rpm}
  s.version = "2.9.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bill Kayser"]
  s.date = %q{2009-07-22}
  s.description = %q{New Relic Ruby Performance Monitoring Agent}
  s.email = %q{bkayser@newrelic.com}
  s.executables = ["mongrel_rpm", "newrelic_cmd"]
  s.extra_rdoc_files = ["bin/mongrel_rpm", "bin/newrelic_cmd", "CHANGELOG", "lib/new_relic/agent/agent.rb", "lib/new_relic/agent/chained_call.rb", "lib/new_relic/agent/collection_helper.rb", "lib/new_relic/agent/error_collector.rb", "lib/new_relic/agent/instrumentation/active_merchant.rb", "lib/new_relic/agent/instrumentation/active_record_instrumentation.rb", "lib/new_relic/agent/instrumentation/controller_instrumentation.rb", "lib/new_relic/agent/instrumentation/data_mapper.rb", "lib/new_relic/agent/instrumentation/dispatcher_instrumentation.rb", "lib/new_relic/agent/instrumentation/error_instrumentation.rb", "lib/new_relic/agent/instrumentation/memcache.rb", "lib/new_relic/agent/instrumentation/merb/controller.rb", "lib/new_relic/agent/instrumentation/merb/dispatcher.rb", "lib/new_relic/agent/instrumentation/merb/errors.rb", "lib/new_relic/agent/instrumentation/passenger_instrumentation.rb", "lib/new_relic/agent/instrumentation/rails/action_controller.rb", "lib/new_relic/agent/instrumentation/rails/action_web_service.rb", "lib/new_relic/agent/instrumentation/rails/dispatcher.rb", "lib/new_relic/agent/instrumentation/rails/errors.rb", "lib/new_relic/agent/method_tracer.rb", "lib/new_relic/agent/patch_const_missing.rb", "lib/new_relic/agent/sampler.rb", "lib/new_relic/agent/samplers/cpu_sampler.rb", "lib/new_relic/agent/samplers/memory_sampler.rb", "lib/new_relic/agent/samplers/mongrel_sampler.rb", "lib/new_relic/agent/shim_agent.rb", "lib/new_relic/agent/stats_engine.rb", "lib/new_relic/agent/transaction_sampler.rb", "lib/new_relic/agent/worker_loop.rb", "lib/new_relic/agent.rb", "lib/new_relic/commands/deployments.rb", "lib/new_relic/commands/new_relic_commands.rb", "lib/new_relic/control/merb.rb", "lib/new_relic/control/rails.rb", "lib/new_relic/control/ruby.rb", "lib/new_relic/control.rb", "lib/new_relic/local_environment.rb", "lib/new_relic/merbtasks.rb", "lib/new_relic/metric_data.rb", "lib/new_relic/metric_parser/action_mailer.rb", "lib/new_relic/metric_parser/active_merchant.rb", "lib/new_relic/metric_parser/active_record.rb", "lib/new_relic/metric_parser/controller.rb", "lib/new_relic/metric_parser/controller_cpu.rb", "lib/new_relic/metric_parser/database.rb", "lib/new_relic/metric_parser/errors.rb", "lib/new_relic/metric_parser/mem_cache.rb", "lib/new_relic/metric_parser/view.rb", "lib/new_relic/metric_parser/web_service.rb", "lib/new_relic/metric_parser.rb", "lib/new_relic/metric_spec.rb", "lib/new_relic/metrics.rb", "lib/new_relic/noticed_error.rb", "lib/new_relic/rack/metric_app.rb", "lib/new_relic/rack/newrelic.ru", "lib/new_relic/rack/newrelic.yml", "lib/new_relic/rack.rb", "lib/new_relic/recipes.rb", "lib/new_relic/stats.rb", "lib/new_relic/transaction_analysis.rb", "lib/new_relic/transaction_sample.rb", "lib/new_relic/version.rb", "lib/new_relic_api.rb", "lib/newrelic_rpm.rb", "lib/tasks/all.rb", "lib/tasks/install.rake", "lib/tasks/tests.rake", "LICENSE", "README.md"]
  s.files = ["bin/mongrel_rpm", "bin/newrelic_cmd", "cert/cacert.pem", "CHANGELOG", "init.rb", "install.rb", "lib/new_relic/agent/agent.rb", "lib/new_relic/agent/chained_call.rb", "lib/new_relic/agent/collection_helper.rb", "lib/new_relic/agent/error_collector.rb", "lib/new_relic/agent/instrumentation/active_merchant.rb", "lib/new_relic/agent/instrumentation/active_record_instrumentation.rb", "lib/new_relic/agent/instrumentation/controller_instrumentation.rb", "lib/new_relic/agent/instrumentation/data_mapper.rb", "lib/new_relic/agent/instrumentation/dispatcher_instrumentation.rb", "lib/new_relic/agent/instrumentation/error_instrumentation.rb", "lib/new_relic/agent/instrumentation/memcache.rb", "lib/new_relic/agent/instrumentation/merb/controller.rb", "lib/new_relic/agent/instrumentation/merb/dispatcher.rb", "lib/new_relic/agent/instrumentation/merb/errors.rb", "lib/new_relic/agent/instrumentation/passenger_instrumentation.rb", "lib/new_relic/agent/instrumentation/rails/action_controller.rb", "lib/new_relic/agent/instrumentation/rails/action_web_service.rb", "lib/new_relic/agent/instrumentation/rails/dispatcher.rb", "lib/new_relic/agent/instrumentation/rails/errors.rb", "lib/new_relic/agent/method_tracer.rb", "lib/new_relic/agent/patch_const_missing.rb", "lib/new_relic/agent/sampler.rb", "lib/new_relic/agent/samplers/cpu_sampler.rb", "lib/new_relic/agent/samplers/memory_sampler.rb", "lib/new_relic/agent/samplers/mongrel_sampler.rb", "lib/new_relic/agent/shim_agent.rb", "lib/new_relic/agent/stats_engine.rb", "lib/new_relic/agent/transaction_sampler.rb", "lib/new_relic/agent/worker_loop.rb", "lib/new_relic/agent.rb", "lib/new_relic/commands/deployments.rb", "lib/new_relic/commands/new_relic_commands.rb", "lib/new_relic/control/merb.rb", "lib/new_relic/control/rails.rb", "lib/new_relic/control/ruby.rb", "lib/new_relic/control.rb", "lib/new_relic/local_environment.rb", "lib/new_relic/merbtasks.rb", "lib/new_relic/metric_data.rb", "lib/new_relic/metric_parser/action_mailer.rb", "lib/new_relic/metric_parser/active_merchant.rb", "lib/new_relic/metric_parser/active_record.rb", "lib/new_relic/metric_parser/controller.rb", "lib/new_relic/metric_parser/controller_cpu.rb", "lib/new_relic/metric_parser/database.rb", "lib/new_relic/metric_parser/errors.rb", "lib/new_relic/metric_parser/mem_cache.rb", "lib/new_relic/metric_parser/view.rb", "lib/new_relic/metric_parser/web_service.rb", "lib/new_relic/metric_parser.rb", "lib/new_relic/metric_spec.rb", "lib/new_relic/metrics.rb", "lib/new_relic/noticed_error.rb", "lib/new_relic/rack/metric_app.rb", "lib/new_relic/rack/newrelic.ru", "lib/new_relic/rack/newrelic.yml", "lib/new_relic/rack.rb", "lib/new_relic/recipes.rb", "lib/new_relic/stats.rb", "lib/new_relic/transaction_analysis.rb", "lib/new_relic/transaction_sample.rb", "lib/new_relic/version.rb", "lib/new_relic_api.rb", "lib/newrelic_rpm.rb", "lib/tasks/all.rb", "lib/tasks/install.rake", "lib/tasks/tests.rake", "LICENSE", "Manifest", "newrelic.yml", "Rakefile", "README.md", "recipes/newrelic.rb", "test/active_record_fixtures.rb", "test/config/newrelic.yml", "test/config/test_control.rb", "test/new_relic/agent/active_record_instrumentation_test.rb", "test/new_relic/agent/agent_test.rb", "test/new_relic/agent/agent_test_controller.rb", "test/new_relic/agent/classloader_patch_test.rb", "test/new_relic/agent/collection_helper_test.rb", "test/new_relic/agent/controller_test.rb", "test/new_relic/agent/dispatcher_instrumentation_test.rb", "test/new_relic/agent/error_collector_test.rb", "test/new_relic/agent/method_tracer_test.rb", "test/new_relic/agent/metric_data_test.rb", "test/new_relic/agent/mock_ar_connection.rb", "test/new_relic/agent/mock_scope_listener.rb", "test/new_relic/agent/stats_engine_test.rb", "test/new_relic/agent/testable_agent.rb", "test/new_relic/agent/transaction_sample_builder_test.rb", "test/new_relic/agent/transaction_sample_test.rb", "test/new_relic/agent/transaction_sampler_test.rb", "test/new_relic/agent/worker_loop_test.rb", "test/new_relic/control_test.rb", "test/new_relic/deployments_api_test.rb", "test/new_relic/environment_test.rb", "test/new_relic/metric_parser_test.rb", "test/new_relic/metric_spec_test.rb", "test/new_relic/samplers_test.rb", "test/new_relic/shim_agent_test.rb", "test/new_relic/stats_test.rb", "test/new_relic/version_number_test.rb", "test/test_helper.rb", "test/ui/newrelic_controller_test.rb", "test/ui/newrelic_helper_test.rb", "ui/controllers/newrelic_controller.rb", "ui/helpers/google_pie_chart.rb", "ui/helpers/newrelic_helper.rb", "ui/views/layouts/newrelic_default.rhtml", "ui/views/newrelic/_explain_plans.rhtml", "ui/views/newrelic/_sample.rhtml", "ui/views/newrelic/_segment.rhtml", "ui/views/newrelic/_segment_limit_message.rhtml", "ui/views/newrelic/_segment_row.rhtml", "ui/views/newrelic/_show_sample_detail.rhtml", "ui/views/newrelic/_show_sample_sql.rhtml", "ui/views/newrelic/_show_sample_summary.rhtml", "ui/views/newrelic/_sql_row.rhtml", "ui/views/newrelic/_stack_trace.rhtml", "ui/views/newrelic/_table.rhtml", "ui/views/newrelic/explain_sql.rhtml", "ui/views/newrelic/images/arrow-close.png", "ui/views/newrelic/images/arrow-open.png", "ui/views/newrelic/images/blue_bar.gif", "ui/views/newrelic/images/file_icon.png", "ui/views/newrelic/images/gray_bar.gif", "ui/views/newrelic/images/new_relic_rpm_desktop.gif", "ui/views/newrelic/index.rhtml", "ui/views/newrelic/javascript/prototype-scriptaculous.js", "ui/views/newrelic/javascript/transaction_sample.js", "ui/views/newrelic/sample_not_found.rhtml", "ui/views/newrelic/show_sample.rhtml", "ui/views/newrelic/show_source.rhtml", "ui/views/newrelic/stylesheets/style.css", "ui/views/newrelic/threads.rhtml", "newrelic_rpm.gemspec"]
  s.homepage = %q{http://www.newrelic.com}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Newrelic_rpm", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{newrelic}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{New Relic Ruby Performance Monitoring Agent}
  s.test_files = ["test/config/test_control.rb", "test/new_relic/agent/active_record_instrumentation_test.rb", "test/new_relic/agent/agent_test.rb", "test/new_relic/agent/classloader_patch_test.rb", "test/new_relic/agent/collection_helper_test.rb", "test/new_relic/agent/controller_test.rb", "test/new_relic/agent/dispatcher_instrumentation_test.rb", "test/new_relic/agent/error_collector_test.rb", "test/new_relic/agent/method_tracer_test.rb", "test/new_relic/agent/metric_data_test.rb", "test/new_relic/agent/stats_engine_test.rb", "test/new_relic/agent/transaction_sample_builder_test.rb", "test/new_relic/agent/transaction_sample_test.rb", "test/new_relic/agent/transaction_sampler_test.rb", "test/new_relic/agent/worker_loop_test.rb", "test/new_relic/control_test.rb", "test/new_relic/deployments_api_test.rb", "test/new_relic/environment_test.rb", "test/new_relic/metric_parser_test.rb", "test/new_relic/metric_spec_test.rb", "test/new_relic/samplers_test.rb", "test/new_relic/shim_agent_test.rb", "test/new_relic/stats_test.rb", "test/new_relic/version_number_test.rb", "test/test_helper.rb", "test/ui/newrelic_controller_test.rb", "test/ui/newrelic_helper_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
