enum Paths {
  mixyrLogo,
  warning,
  mail,
  user,
  lottieLike,

  /// There are 5 gradient images for now with all .jpg so you must add the {number}.jpg at the end
  gradientImage,
  google,
  lottieTree,
  defaultAlbumArt,

  /// To the internet
  googleSearch
}

const Map<Paths, String> paths = {
  Paths.mixyrLogo: 'assets/icons/mixyr_logo.svg',
  Paths.warning: 'assets/icons/warning.svg',
  Paths.user: 'assets/icons/user.svg',
  Paths.gradientImage: 'assets/images/gradient',
  Paths.defaultAlbumArt: 'assets/images/default-album-art.png',
  Paths.google: 'assets/images/google.png',
  Paths.lottieLike: 'assets/lottie/like.json',
  Paths.lottieTree: 'assets/lottie/tree.json',
  Paths.googleSearch: 'https://www.google.com/search?q='
};
