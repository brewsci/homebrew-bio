class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/mmdb2-2.0.22.tar.gz"
  sha256 "a9646933ce9f34633e1ae4901f2383af0e5318d6490851328f5b6aa06195ab51"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "efb676f98815a12b86c0e0a1232e4dca4b216ce17ebabadac026ae8ea162c43e"
    sha256 cellar: :any,                 arm64_sonoma:  "2781899eb49518bf404825ad80f3026f4b85ace6a5211d75390c5092459113a3"
    sha256 cellar: :any,                 ventura:       "25b312d673298b4460f25a5e8a992f87550c4bdc2157ba7c77174e6f1a7a6257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2625deed9366f07dcc3580f9818e370a8023557dd9e595673a86100bc3e33276"
  end

  depends_on "pkg-config" => [:build, :test]

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-static
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags mmdb2")
  end
end
