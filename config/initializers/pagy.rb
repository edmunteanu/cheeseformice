############ Global Options ################################################################
# See https://ddnexus.github.io/pagy/toolbox/options/ for details.
Pagy.options[:limit] = 25
Pagy.options[:size] = 3
Pagy.options[:max_pages] = 200

############ JavaScript ####################################################################
# See https://ddnexus.github.io/pagy/resources/javascript/ for details.
Rails.application.config.assets.paths << Pagy::ROOT.join("javascripts")

############# Overriding Pagy::I18n Lookup #################################################
# Refer to https://ddnexus.github.io/pagy/resources/i18n/ for details.
Pagy::I18n.pathnames << Rails.root.join("config/locales/pagy")
