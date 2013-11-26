require 'spree_core'
require 'homepager_hooks'

module Homepager
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      ProductsController.class_eval do
        def index
          collection
          @products = Product.on_homepage.active if (params[:keywords].blank? and params[:product_group_name].blank?)
        end
      end

      Product.class_eval do
        scope :on_homepage,:conditions => ["show_on_homepage = ?", true]
      end

    end

    config.to_prepare &method(:activate).to_proc
  end
end
