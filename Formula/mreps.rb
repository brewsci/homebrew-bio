class Mreps < Formula
  # Kolpakov_2003: "https://doi.org/10.1093/nar/gkg617"
  desc "Identifying serial/tandem in DNA sequences"
  homepage "https://github.com/gregorykucherov/mreps"
  url "https://github.com/gregorykucherov/mreps/archive/2.6.01.tar.gz"
  sha256 "fde80804d7d4381b09d2dcf85bc6b01f8b06577972ce6123ca934de0fa0ea938"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "18da69d83b028a26c6202a9879d3af24d8e678ff36f1cd25979df3dc91c511ac" => :mojave
    sha256 "0c7d4a4f202cd4885d25b470d02baa22f7ff8d816c9df7789bc57847a8f13bd7" => :x86_64_linux
  end

  def install
    # https://github.com/gregorykucherov/mreps/issues/6
    rm "test/.DS_Store"
    system "make"
    bin.install "mreps"
    pkgshare.install "test"
  end

  test do
    # https://github.com/gregorykucherov/mreps/issues/5
    assert_match "2.6", shell_output("#{bin}/mreps -version 2>&1")
    assert_match "tandemly", shell_output("#{bin}/mreps -help 2>&1")
    assert_match "There is 1 repeat", shell_output("#{bin}/mreps -fasta #{pkgshare}/test/sequence.fasta")
  end
end
