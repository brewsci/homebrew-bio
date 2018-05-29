class LinksScaffolder < Formula
  # cite Warren_2015: "https://doi.org/10.1186/s13742-015-0076-3"
  desc "Long Interval Nucleotide K-mer Scaffolder"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  url "https://github.com/bcgsc/LINKS/releases/download/v1.8.6/links_v1-8-6.tar.gz"
  version "1.8.6"
  sha256 "0930f60ef300dda533247a46e77bbec9f1f9508e5fc4a97728ed5fd40a7614ed"
  head "https://github.com/bcgsc/LINKS.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "fcd061118391b4bb7975f79596319090033e4181904eed54ce070470d11dada2" => :sierra_or_later
    sha256 "5532580f2bebf2c3964f1e79be2a8daa2357946dd88f6d480568d7d6210e27cb" => :x86_64_linux
  end

  depends_on "swig" => :build
  depends_on "perl"

  def install
    if OS.mac?
      # Fix error: no known conversion from 'size_t' (aka 'unsigned long') to 'uint64_t &' (aka 'unsigned long long &')
      cd "lib/bloomfilter" do
        inreplace ["BloomFilter.hpp", "RollingHash.h", "RollingHashIterator.h", "swig/BloomFilter.i"],
          "size_t", "uint64_t"
      end
    end

    cd "lib/bloomfilter/swig" do
      so = OS.mac? ? "bundle" : "so"
      perl = Dir[Formula["perl"].lib/"perl5/*/*/CORE"][0]
      cxxflags = (ENV.cxxflags || "").split
      system "swig", "-Wall", "-c++", "-perl5", "BloomFilter.i"
      system ENV.cxx, *cxxflags, "-c", "-fPIC", "-I#{perl}", "BloomFilter_wrap.cxx"
      system ENV.cxx, *cxxflags, "-shared", "-o", "BloomFilter.#{so}", "BloomFilter_wrap.o", "-L#{perl}", "-lperl"
      libexec.install "BloomFilter.pm", "BloomFilter.#{so}"
    end

    inreplace "LINKS", "/usr/bin/env perl", Formula["perl"].bin/"perl"
    inreplace "LINKS", "$FindBin::Bin/./lib/bloomfilter/swig", "$FindBin::RealBin/../libexec"
    bin.install "LINKS"
    prefix.install "test"
    prefix.install "tools"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/LINKS", 255)
  end
end
