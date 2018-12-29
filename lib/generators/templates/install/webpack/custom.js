const {
  environment
} = require('@rails/webpacker')
const webpack = require('webpack')

module.exports = {
  resolve: {
    alias: {
      jquery: 'jquery/src/jquery'
    }
  }
}

// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
});


// Insert before a given plugin
environment.plugins.insert('CommonChunkVendor',
  new webpack.optimize.CommonsChunkPlugin({
    name: 'vendor', // Vendor code
    minChunks: (module) => module.context && module.context.indexOf('node_modules') !== -1
  }), {
    before: 'manifest'
  })

// Add an additional plugin of your choosing : ProvidePlugin
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
  })
)
