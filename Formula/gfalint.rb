class Gfalint < Formula
  desc "Check a GFA file for syntax errors"
  homepage "http://sjackman.ca/gfalint/"
  url "https://github.com/sjackman/gfalint/releases/download/1.0.0/gfalint-1.0.0.tar.gz"
  sha256 "0db8d5b8f1379bcb76ccc3c7e72d933b7f4f865aa63fe60d4603a6057b18bede"
  head "https://github.com/sjackman/gfalint.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "df40acd7ebcce869c0ffa8538d6a105a73737ffae107fda0f6ea561f36893331" => :sierra
    sha256 "8e82b29cec5636771ea2f2b9447f4083acbaa1efcc392f5ec64fe6c45bcad4c8" => :x86_64_linux
  end

  head do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    # Fix error: 'gfay.h' file not found
    ENV.deparallelize { system "make" } if build.head?
    system "make", "check"
    system "make", "install"
  end

  test do
    Dir[doc/"examples/*.gfa"].each do |f|
      assert_equal "", shell_output("#{bin}/gfalint #{f}")
    end
  end
end
