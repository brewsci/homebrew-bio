class Sumaclust < Formula
  desc "Fast and exact sequence clustering for DNA metabarcoding"
  homepage "https://git.metabarcoding.org/obitools/sumaclust/wikis/home"
  url "https://git.metabarcoding.org/obitools/sumaclust/uploads/59ff189079b9e318f07b9ff9d5fee54b/sumaclust_v1.0.31.tar.gz"
  sha256 "a7c122ff90671d8589deb05a1a8b008e8f439103bb0b7eca48c3d6da205cf2f2"

  def install
    if OS.mac?
      system "make", "CC=clang"
    else
      system "make"
    end
    bin.install "sumaclust"
    doc.install "sumaclust_user_manual.pdf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sumaclust -h 2>&1")
  end
end
