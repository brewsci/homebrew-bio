class LinksScaffolder < Formula
  # cite Warren_2015: "https://doi.org/10.1186/s13742-015-0076-3"
  desc "Long Interval Nucleotide K-mer Scaffolder"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  url "https://github.com/bcgsc/LINKS/releases/download/v1.8.7/links_v1-8-7.tar.gz"
  version "1.8.7"
  sha256 "3401a2694a3545cb7bf3fb13a5854e5d1c5b87200cad998d967fe8e0fc980e1c"
  head "https://github.com/bcgsc/LINKS.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "38c2914cb3cf216cc6890a17e95d5fedfb254ed98dbd675d6eed06e078663e07" => :sierra
    sha256 "80798b8417f1e1fc330cdcd3e499769c1202663df57707be695207d4831ec687" => :x86_64_linux
  end

  depends_on "swig" => :build
  depends_on "perl"

  def install
    if OS.mac?
      # Fix error: no known conversion from 'size_t' (aka 'unsigned long') to 'uint64_t &' (aka 'unsigned long long &')
      cd "lib/bloomfilter" do
        inreplace ["BloomFilter.hpp", "nthash.hpp", "ntHashIterator.hpp", "swig/BloomFilter.i", "KmerBloomFilter.hpp"],
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
