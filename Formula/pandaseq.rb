class Pandaseq < Formula
  # cite Masella_2012: "https://doi.org/10.1186/1471-2105-13-31"
  desc "PAired-eND Assembler for DNA sequences"
  homepage "https://github.com/neufeld/pandaseq"
  url "https://github.com/neufeld/pandaseq/archive/v2.11.tar.gz"
  sha256 "6e3e35d88c95f57d612d559e093656404c1d48c341a8baa6bef7bb0f09fc8f82"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "libtool"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # https://github.com/neufeld/pandaseq/issues/75
    assert_match version.to_s, shell_output("#{bin}/pandaseq -h 2>&1", 1)
  end
end
