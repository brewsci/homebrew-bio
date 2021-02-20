class Trimadap < Formula
  desc "Fast but inaccurate adapter trimmer for Illumina reads"
  homepage "https://github.com/lh3/trimadap"
  url "https://github.com/lh3/trimadap/archive/ddfef210563830d9193b40949da3523b6fb93003.tar.gz"
  version "0.1.11"
  sha256 "0aad29cc8f2fb65b464785b5787a29c0e0a6eab59f08eea82dffe15165151d4f"
  head "https://github.com/lh3/trimadap.git"

  livecheck do
    url "https://raw.githubusercontent.com/lh3/trimadap/master/trimadap-mt.c"
    regex(/^#define VERSION "r(\d+)"$/i)
    strategy :page_match do |page, regex|
      version = page[regex, 1]
      version.present? ? "0.1.#{version}" : []
    end
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, sierra:       "d55f3e6d04a44e747d1fc0b8b279c44518be18d198ceb746052d02dbb2442d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "763804b091eba6b97a3276e73e8c05c761ab5e1836fb2fee9038e08aa0e8096d"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "trimadap-mt"
    doc.install "illumina.txt", "test.fa"
    bin.install_symlink "trimadap-mt" => "trimadap"
  end

  test do
    assert_match(/^1 +ATCTCGTATGCCGTCTTCTGCTTG$/, shell_output("#{bin}/trimadap #{doc}/test.fa 2>&1"))
  end
end
