class Sibelia < Formula
  # cite Minkin_2013: "https://doi.org/10.1007/978-3-642-40453-5_17"
  desc "Synteny Block ExpLoration tool"
  homepage "http://bioinf.spbau.ru/sibelia"
  url "https://github.com/bioinf/Sibelia/archive/v3.0.7.tar.gz"
  sha256 "bfc530190967cadd2d1e9779eeb1700f494c115049da878116c4540c5586e813"

  depends_on "cmake" => :build
  depends_on "python"
  
  def install
    # Reduce memory usage for CircleCI. 
    ENV["MAKEFLAGS"] = "-j16" if ENV["CIRCLECI"]
    
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
    assert_match "loose", shell_output("#{bin}/Sibelia -h 2>&1")
    assert_match "assembly", shell_output("#{bin}/C-Sibelia.py -h 2>&1")
    assert_match "variants", shell_output("#{bin}/snpEffAnnotate.py -h 2>&1")
  end
end
