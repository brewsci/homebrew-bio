class Phlawd < Formula
  # cite Smith_2009: "https://doi.org/10.1186/1471-2148-9-37"
  desc "Phylogenetic dataset construction"
  homepage "https://github.com/jonchang/phlawd"
  url "https://github.com/jonchang/phlawd/archive/3.4b.tar.gz"
  version "3.4b"
  sha256 "a0fea43866e425f7fed5f74bcb8c391484a10b486f3f03d5b7bbc4df84dd84b8"
  revision 2

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ad5daf13faa785f34a1ca49dff3807791c28db24de091ae6b56042b7322dc2ad" => :sierra
    sha256 "41fd5fa09423ecabdc64a893e08186eb07714f3f63b5d065175ca5a8a653492b" => :x86_64_linux
  end

  depends_on "brewsci/bio/muscle"
  depends_on "brewsci/bio/quicktree"
  depends_on "libomp" if OS.mac?
  depends_on "mafft"
  depends_on "wget"

  uses_from_macos "sqlite"

  def install
    ENV.append_to_cflags "-mmacosx-version-min=10.12 -lomp" if OS.mac?
    sql = OS.mac? ? "sqlitewrapped-1.3.1.MAC.tgz" : "sqlitewrapped-1.3.1.tar.gz"

    cd "deps" do
      system "tar", "xf", sql, "--strip-components=1"
      system "make"
    end

    cd "src" do
      inreplace "Makefile.in" do |s|
        s.gsub! "fopenmp", "fopenmp @CFLAGS@"
        s.gsub! "deps/$(HOST)", "deps"
      end

      if OS.mac?
        system "./configure", "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp"
      else
        system "./configure"
      end

      system "make"
      bin.install "PHLAWD"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/PHLAWD")
  end
end
