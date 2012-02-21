module EdgeAuth
  class Engine < ::Rails::Engine
    isolate_namespace EdgeAuth
    config.generators do |g|
      g.test_framework      :rspec, :view_specs => false
      g.fixture_replacement :factory_girl
      g.orm                 :mongoid
    end
  end
end
