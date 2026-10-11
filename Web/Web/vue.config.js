module.exports = {
  // Legacy thread-loader workers can stall on newer Node versions.
  parallel: false,
  css: {
    loaderOptions: {
      sass: { implementation: require('sass') }
    }
  }
};
