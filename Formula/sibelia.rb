class Sibelia < Formula
  # cite Minkin_2013: "https://doi.org/10.1007/978-3-642-40453-5_17"
  desc "Synteny Block ExpLoration tool"
  homepage "http://bioinf.spbau.ru/sibelia"
  url "https://github.com/bioinf/Sibelia/archive/v3.0.7.tar.gz"
  sha256 "bfc530190967cadd2d1e9779eeb1700f494c115049da878116c4540c5586e813"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "2edffd9444a1730c681f44725e6c31c3659e5f0bc6155b4e4b4899fe5351341b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "276b51347bcfe63f42c1cf24f21c765dd862549806ee6cca97a49024eb86b44b"
  end

  depends_on "cmake" => :build
  depends_on "python"
  depends_on "snpeff"

  def install
    # 'build' folder already exists
    mkdir "build" do
      system "cmake", "../src", *std_cmake_args
      system "make"
      system "make", "install"
    end

    # Fix python hashbang
    Dir[bin/"*.py"].each do |exe|
      inreplace exe, "/usr/bin/python", "/usr/bin/env python"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/Sibelia --version 2>&1")
  end
end
