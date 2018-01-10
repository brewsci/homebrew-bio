class BioFoo < Formula
  desc "Test formula"
  homepage "https://gist.githubusercontent.com/sjackman/021c1d377a1265971a63484de4bdd28f"
  url "https://gist.githubusercontent.com/sjackman/021c1d377a1265971a63484de4bdd28f/raw/b76228fd63ea83baef6d5b648a6c94b63563171b/hello.c"
  version "1.0"
  sha256 "897e5a4ee125ab09f2da4e2bcaf6cc4532cc5da6a2fa8251be4c349acaaa10ec"

  def install
    system "make", "hello"
    bin.install "hello" => "sandbox-foo"
  end

  test do
    assert_match "Hello, world!", shell_output("#{bin}/sandbox-foo")
  end
end
