class Phlawd < Formula
  # cite Smith_2009: "https://doi.org/10.1186/1471-2148-9-37"
  desc "Phylogenetic dataset construction"
  homepage "https://github.com/jonchang/phlawd"
  url "https://github.com/jonchang/phlawd/archive/3.4b.tar.gz"
  version "3.4b"
  sha256 "a0fea43866e425f7fed5f74bcb8c391484a10b486f3f03d5b7bbc4df84dd84b8"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ad5daf13faa785f34a1ca49dff3807791c28db24de091ae6b56042b7322dc2ad" => :sierra
    sha256 "41fd5fa09423ecabdc64a893e08186eb07714f3f63b5d065175ca5a8a653492b" => :x86_64_linux
  end

  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "sqlite"
  end
  depends_on "mafft"
  depends_on "muscle"
  depends_on "quicktree"
  depends_on "wget"

  fails_with :clang # needs openmp

  def install
    if OS.mac?
      # Work around syslog.h errors
      ENV.append_to_cflags "-mmacosx-version-min=10.12"
    else
      # Recompile libsqlitewrapped due to stdlib changes
      cd "deps" do
        system "tar", "xf", "sqlitewrapped-1.3.1.tar.gz"
        cd "sqlitewrapped-1.3.1" do
          system "make"
        end
      end
    end

    cd "src" do
      inreplace "Makefile.in" do |s|
        s.gsub! "fopenmp", "fopenmp @CFLAGS@"
        s.gsub! "deps/$(HOST)", "deps/sqlitewrapped-1.3.1" if OS.linux?
      end
      system "./configure"
      system "make"
      bin.install "PHLAWD"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/PHLAWD")
  end
end
