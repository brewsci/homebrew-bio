class Biomake < Formula
  # cite Holmes_2016: "https://doi.org/10.1101/093245"
  desc "GNU-Make-like utility for managing builds and complex workflows"
  homepage "https://github.com/evoldoers/biomake"
  url "https://github.com/evoldoers/biomake/archive/v0.1.5.tar.gz"
  sha256 "630009c52472b97dfb22304330fe809abd5e038e8b0b6aa084c7fc437b8cd6a0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "392c08b1568213df278806f7565c254ebadae455e010803e3b748efffbbd73e5" => :sierra
    sha256 "7f74baac28c1761084e6a22c7595ba9002201540633e149e7e43270838f6cb0b" => :x86_64_linux
  end

  depends_on "swi-prolog"

  def install
    inreplace "bin/biomake", "$PATH_TO_ME/swipl_wrap", "swipl"
    rm ["bin/swipl_wrap", "Makefile"]
    rm_r "t"
    prefix.install Dir["*"]
  end

  test do
    assert_match "Options", shell_output("#{bin}/biomake -h")
    (testpath/"Makefile").write "default: ; echo Homebrew"
    assert_match /^Homebrew$/, shell_output("#{bin}/biomake")
  end
end
