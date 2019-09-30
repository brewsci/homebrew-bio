class LinksScaffolder < Formula
  # cite Warren_2015: "https://doi.org/10.1186/s13742-015-0076-3"
  desc "Long Interval Nucleotide K-mer Scaffolder"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/links"
  url "https://github.com/bcgsc/LINKS/releases/download/v1.8.7/links_v1-8-7.tar.gz"
  version "1.8.7"
  sha256 "3401a2694a3545cb7bf3fb13a5854e5d1c5b87200cad998d967fe8e0fc980e1c"
  revision 1
  head "https://github.com/bcgsc/LINKS.git"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "f00d027ea4ae9195eb35590128e07514a0d558829d682358b0bd66592e50f821" => :sierra
    sha256 "dc7326911e2fb969cf4ad5720a95a3d924aff737fd547fb16db89346a473a691" => :x86_64_linux
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
