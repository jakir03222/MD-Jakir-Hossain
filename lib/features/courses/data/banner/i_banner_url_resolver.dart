/// Resolves CDN banner URLs when API returns broken host paths.
abstract class IBannerUrlResolver {
  String resolve(String rawUrl);
}

class BiddabariBannerUrlResolver implements IBannerUrlResolver {
  static const _brokenHost = 'https://api.biddabari.com/';
  static const _cdnHost =
      'https://storage.biddabari.online/biddabari-bucket/';

  @override
  String resolve(String rawUrl) {
    final url = rawUrl.trim();
    if (url.isEmpty) return url;
    if (url.startsWith(_brokenHost)) {
      return url.replaceFirst(_brokenHost, _cdnHost);
    }
    return url;
  }
}
