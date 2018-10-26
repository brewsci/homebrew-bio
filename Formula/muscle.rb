class Muscle < Formula
  # cite Edgar_2004: "https://doi.org/10.1186/1471-2105-5-113"
  desc "Multiple sequence alignment program"
  homepage "https://www.drive5.com/muscle/"
  url "https://www.drive5.com/muscle/muscle_src_3.8.1551.tar.gz"
  sha256 "c70c552231cd3289f1bad51c9bd174804c18bb3adcf47f501afec7a68f9c482e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "facb165df0b74683682971e5570332a1dcb111720f853fb3ecae4de63509c3a2" => :sierra
    sha256 "bb3bd2fc6f97b35f5427dbbe75aa8dc8fefc6bc49566f000d669004c641cde8e" => :x86_64_linux
  end

  def install
    # Fix build per Makefile instructions
    inreplace "Makefile", "-static", ""
    system "make"
    bin.install "muscle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muscle -version")
  end
end
