class Libmuscle < Formula
  desc "C/C++ API to the muscle alignment software"
  homepage "https://github.com/marbl/parsnp"
  url "https://github.com/marbl/parsnp/archive/v1.2.tar.gz"
  version "3.7"
  sha256 "c2cbefcf961925c3368476420e28a63741376773f948094ed845a32291bda436"

  def install
    ENV.deparallelize
    cd "muscle" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
      rm bin/"muscle"
      doc.install "AUTHORS", "ChangeLog"
    end
  end

  test do
    assert_predicate lib/"libMUSCLE-3.7.a", :exist?
  end
end
