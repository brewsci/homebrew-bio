class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
    :revision => "26ae172851547b03c8af2942ecfb4ece2a7b905d"
  version "0.6.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9e453f2f3958b904ee68a07b41966d773b78a5018ad9471b536365b5e3a838b3" => :sierra_or_later
    sha256 "a8209facb1b98e08db8d2a54bb78f7b81007d63c1419813b711eee6119d07871" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  unless OS.mac?
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "open-mpi" => :recommended
  end

  resource "example" do
    url "https://sco.h-its.org/exelixis/resource/download/hands-on/dna.phy"
    sha256 "c2adc42823313831b97af76b3b1503b84573f10d9d0d563be5815cde0effe0c2"
  end

  def install
    args = std_cmake_args
    if build.bottle?
      # Bottles are built with -march=core2, so disable AVX instructions
      args += %w[-DENABLE_AVX=false -DENABLE_AVX2=false] if build.bottle?
    else
      args << "-DENABLE_AVX=false" unless Hardware::CPU.avx?
      args << "-DENABLE_AVX2=false" unless Hardware::CPU.avx2?
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      if build.with? "open-mpi"
        system "cmake", "..", *args, "-DUSE_MPI=ON"
        system "make"
      end
    end
    bin.install Dir["bin/raxml-ng*"]
  end

  test do
    testpath.install resource("example")
    args = %w[--all --msa dna.phy --model GTR+G --bs-trees 100 --tree pars{10} --force --threads 2]
    system "#{bin}/raxml-ng", *args
  end
end
