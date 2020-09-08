class Subread < Formula
  # cite Liao_2013: "https://doi.org/10.1093/nar/gkt214"
  desc "High-performance read alignment, quantification and mutation discovery"
  homepage "https://academic.oup.com/nar/article/41/10/e108/1075719"
  url "https://cfhcable.dl.sourceforge.net/project/subread/subread-2.0.1/subread-2.0.1-source.tar.gz"
  sha256 "d808eb5b1823c572cb45a97c95a3c5acb3d8e29aa47ec74e3ca1eb345787c17b"
  license "GPL-3.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f763ea04f616a72c4b61b04ea345a8577f283b0da29d91714241b70e3b0705f5" => :catalina
    sha256 "96a086816e5094e5ff5c2ae7d4f11a0f8e8764afaac7568bdaecaee0f37c9b0d" => :x86_64_linux
  end

  uses_from_macos "zlib"

  def install
    cd "src" do
      if OS.mac?
        system "make", "-f", "Makefile.MacOS"
      else
        system "make", "-f", "Makefile.Linux"
      end

      bin.install Dir["../bin/sub*"]
      bin.install "../bin/exactSNP"
      bin.install "../bin/featureCounts"
      bin.install Dir["../bin/utilities/*"]
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/featureCounts -v 2>&1")
  end
end
