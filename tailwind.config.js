module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/components/**/*'
  ],
  safelist: [
    // For status pill messages dynamic css classes
    {
      pattern: /(bg|border)-(gray|red|green|blue|orange)-(600|800)/,
    }
  ]
}
