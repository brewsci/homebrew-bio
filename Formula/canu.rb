class Canu < Formula
  # cite Koren_2017: "https://doi.org/10.1101/gr.215087.116"
  # cite Koren_2018: "https://doi.org/10.1038/nbt.4277"
  # cite Nurk_2020: "https://doi.org/10.1101/gr.263566.120"
  desc "Single molecule sequence assembler"
  homepage "https://canu.readthedocs.io/en/latest/"
  url "https://github.com/marbl/canu/releases/download/v2.2/canu-2.2.tar.xz"
  sha256 "e4d0c7b82149114f442ccd39e18f7fe2061c63b28d53700ad896e022b73b7404"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, mojave:       "6042a89505e9c8e553289361dfb2f7d99d3168d4234e97a35e5c91eb38c0820d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e211e9b9c1c3ba20669050606188b5025042ca9a03e2034f7fe135afc5431fc0"
  end

  depends_on "boost" => :build
  depends_on "gnuplot"
  depends_on "minimap2"
  depends_on "openjdk"

  uses_from_macos "curl"
  uses_from_macos "perl"

  on_macos do
    depends_on "libomp"
  end

  resource "cpuid.c" do
    url "https://raw.githubusercontent.com/jeffdaily/parasail/master/src/cpuid.c"
    sha256 "8a50ab418d894ae8f2e33848d102d967247d88a73b30323e800535954dd5f0df"
  end

  def install
    resource("cpuid.c").stage do
      cp "cpuid.c", buildpath/"src/utility/src/parasail/cpuid.c"
    end
    if OS.mac?
      inreplace "src/Makefile" do |s|
        # permit the use of clang
        s.gsub! "grep -c clang`), 0", "grep -c clang`), 1"
        # use brew's libomp and boost
        s.gsub! "CXXFLAGS += -fopenmp -pthread -fPIC -m64 -Wno-format",
                "CXXFLAGS += -Xpreprocessor -fopenmp -pthread -fPIC -m64 -Wno-format"
        s.gsub! "-m64 -Wno-format",
                "-m64 -Wno-format -I#{Formula["libomp"].opt_include} -I#{Formula["boost"].opt_include}"
        s.gsub! "-fopenmp -pthread -lm",
                "-Xpreprocessor -fopenmp -pthread -lm -lomp"
        s.gsub! "-pthread -lm -lomp",
                "-pthread -lm -lomp -L#{Formula["libomp"].opt_lib} -L#{Formula["boost"].opt_lib}"
      end
    end
    system "make", "-C", "src",
                   "CC=#{ENV.cc}", "CXX=#{ENV.cxx}",
                   "DESTDIR=#{prefix}"
    # obj directory is not necessary
    rm_r prefix/"build/obj"
    # MHAP is not necessary
    # rm_r prefix/"build/share"
    # install libraries
    lib.install Dir[prefix/"build/lib/libcanu.a"]
    libexec.install Dir[prefix/"build/lib/site_perl"]
    # install binaries and scripts
    libexec.install Dir[prefix/"build/bin/*"]
    inreplace "#{libexec}/canu" do |s|
      s.gsub! "../lib/site_perl", "../libexec/site_perl"
      s.gsub! "$bin/canu.defaults", "#{libexec}/canu.defaults"
    end
    mv Dir[prefix/"build/share"], prefix
    envs = {
      PERL5LIB:  libexec/"site_perl",
      JAVA_HOME: Formula["openjdk"].opt_prefix,
    }
    (bin/"canu").write_env_script libexec/"canu", envs
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/canu --version")
  end
end
