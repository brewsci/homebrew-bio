class Rdock < Formula
  desc "Fast, versatile open source docking program for proteins and nucleic acids"
  homepage "https://rdock.github.io/"
  url "https://github.com/CBDD/rdock/archive/refs/tags/v24.04.204-legacy.tar.gz"
  sha256 "cf5bf35d60254ae74c45f0c5ed3050513bbc8ae8df9c665157eb26f6b5a33d16"
  license "LGPL-3.0-only"
  head "https://github.com/CBDD/rdock.git", branch: "main"

  depends_on "gcc" => :build
  depends_on "numpy"
  depends_on "perl"
  depends_on "popt"
  depends_on "pytest"
  depends_on "python"

  patch do
    url "https://raw.githubusercontent.com/eunos-1128/rDock/66f167d73cbfd5be64eda2ee1ff295ce5c7d3b3f/NMObjective.h.patch"
    sha256 "5633b36c6a5e9f74a3855afd3e05ac9e3c7a588471e7f16ac508736ab093b6f7"
  end

  def install
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-14"

    inreplace "Makefile" do |s|
      s.gsub!(/INCLUDE\s*:=/, "INCLUDE := -I#{Formula["popt"].opt_include} ")
      s.gsub!(/LIB_DEPENDENCIES\s*:=\s*-lpopt/, "LIB_DEPENDENCIES := -L#{Formula["popt"].opt_lib} -lpopt")
    end

    ENV["CXX_EXTRA_FLAGS"] = "-I#{Formula["popt"].opt_include}"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["gcc"].opt_lib}/gcc/14" if OS.mac?
    (share/"lib").mkpath
    cp_r Dir["lib/*"], share/"lib"
    rm Dir["lib/*"]
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    cp_r "data", share
  end

  def caveats
    <<~EOS
      Before running rDock programs, you need to set the `RBT_ROOT` environment variable:
        export RBT_ROOT=#{share}
    EOS
  end

  test do
    # TODO: Update later
    system "#{bin}/rbdock", "--help"
  end
end
