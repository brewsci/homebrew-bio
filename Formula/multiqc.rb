class Multiqc < Formula
  include Language::Python::Virtualenv

  desc "Aggregate bioinformatics analysis reports across many samples and tools"
  homepage "https://multiqc.info/"
  url "https://files.pythonhosted.org/packages/af/a2/90e1b19ee65ec2619a4ff1767deefe32ba16c87f1363864778bd97ee5800/multiqc-1.35.tar.gz"
  sha256 "5a4aa6480e6def2f9c0af2893358bf7ec5c304d606ecf613cd25ddcd0e244e77"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build # for pydantic-core, polars, rpds-py, tiktoken
  depends_on "freetype" # for pillow
  depends_on "jpeg-turbo" # for pillow
  depends_on "python@3.13"

  uses_from_macos "zlib" # for pillow

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ff/9f/897287e955db0f50b12fd69ef45956e4fd2c7ddb48c736872f7ea2314443/boto3-1.43.36.tar.gz"
    sha256 "587d7ee92a12e440ad12b0e7f11f3358f0c4d65b19f64726efc94aaf194aff28"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/7c/37/da9e7f6ca73ac73afd7f0bb7f238aa5daba35c081e98d7f48a7c399599c0/botocore-1.43.36.tar.gz"
    sha256 "4cae47d1b2d426316b85a0087d9e69e048f13bc003b5177d74639fe9dfd28205"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c9/c7/424b75da314c1045981bd9777432fad05a9e0c69daa4ed7e308bbaffe405/certifi-2026.6.17.tar.gz"
    sha256 "024c88eeec92ca068db80f02b8b07c9cef7b9fe261d1d535abfd5abd6f6af432"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "colormath2" do
    url "https://files.pythonhosted.org/packages/a0/d2/ffc1354bdb2e5aa2772782bd34351caf2e98ef2a0850080feda4216178d9/colormath2-3.0.3.tar.gz"
    sha256 "e797613f4f0b86c6c218a1c7dc50f1259e6934e391581969b689ae27379c2ffa"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/ba/66/a3921783d54be8a6870ac4ccffcd15c4dc0dd7fcce51c6d63b8c63935276/humanize-4.15.0.tar.gz"
    sha256 "1dd098483eb1c7ee8e32eb2e99ad1910baefa4b75c3aff3a82f4d78688993b10"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a9/01/15bb152d77b21318514a96f43af312635eb2500c96b55398d020c93d86ea/importlib_metadata-9.0.0.tar.gz"
    sha256 "a4f57ab599e6a2e3016d7595cfd72eb4661a5106e787a95bcc90c7105b831efc"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "kaleido" do
    on_macos do
      on_arm do
        url "https://files.pythonhosted.org/packages/45/8e/4297556be5a07b713bb42dde0f748354de9a6918dee251c0e6bdcda341e7/kaleido-0.2.1-py2.py3-none-macosx_11_0_arm64.whl"
        sha256 "bb9a5d1f710357d5d432ee240ef6658a6d124c3e610935817b4b42da9c787c05"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/e0/f7/0ccaa596ec341963adbb4f839774c36d5659e75a0812d946732b927d480e/kaleido-0.2.1-py2.py3-none-macosx_10_11_x86_64.whl"
        sha256 "ca6f73e7ff00aaebf2843f73f1d3bacde1930ef5041093fe76b83a15785049a7"
      end
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/a1/2b/680662678a57afab1685f0c431c2aba7783ce4344f06ec162074d485d469/kaleido-0.2.1-py2.py3-none-manylinux2014_aarch64.whl"
        sha256 "845819844c8082c9469d9c17e42621fbf85c2b237ef8a86ec8a8527f98b6512a"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/ae/b3/a0f0f4faac229b0011d8c4a7ee6da7c2dca0b6fd08039c95920846f23ca4/kaleido-0.2.1-py2.py3-none-manylinux1_x86_64.whl"
        sha256 "aa21cf1bf1c78f8fa50a9f7d45e1003c387bd3d6fe0a767cfbbf344b95bdc3a8"
      end
    end
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/2b/f4/69fa6ed85ae003c2378ffa8f6d2e3234662abd02c10d216c0ba96081a238/markdown-3.10.2.tar.gz"
    sha256 "994d51325d25ad8aa7ce4ebaec003febcce822c3f8c911e3b17c52f7f589f950"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/62/3c/c4ef2164a71c1a63d7f1ae411c4082c5fa872405106db60a4b7114989ad7/narwhals-2.22.1.tar.gz"
    sha256 "d62920805a0a43b7ff8b54b0c0d3142d796f8a9301836ada37e573d6a33cbcd9"
  end

  resource "natsort" do
    url "https://files.pythonhosted.org/packages/e2/a9/a0c57aee75f77794adaf35322f8b6404cbd0f89ad45c87197a937764b7d0/natsort-8.4.0.tar.gz"
    sha256 "45312c4a0e5507593da193dedd04abb1469253b601ecaf63445ad80f0a1ea581"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6a/51/63fe664f3908c97be9d2e4f1158eb633317598cfa6e1fc14af5383f17512/networkx-3.6.1.tar.gz"
    sha256 "26b7c357accc0c8cde558ad486283728b65b6a95d85ee1cd66bafab4c8168509"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/e7/05/3d27272d30698dc0ecb7fdfaa41ad70303b444f81722bb99bce1d818638a/numpy-2.5.0.tar.gz"
    sha256 "5a129578019311b6e56bdd714250f19b518f7dceeeb8d1af5490f4942d3f891c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/8c/21/c2bcdd5906101a30244eaffc1b6e6ce71a31bd0742a01eb89e660ebfac2d/pillow-12.2.0.tar.gz"
    sha256 "a830b1a40919539d07806aa58e1b114df53ddd43213d9c8b75847eee6c0182b5"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/94/fd/d72c292d78aadb93d1a9bcd76bf3c678271040c7cf10abe5788b33040a39/plotly-6.8.0.tar.gz"
    sha256 "e088e7ddc68d4f70e3d66659224727a45296d71d2b8284181862d3d8f1f0d88f"
  end

  resource "polars" do
    url "https://files.pythonhosted.org/packages/cb/91/a1d7809a6d399f0aa78d4d3a4f4daf411cb97ccfe7f236c08a01be5fc8a5/polars-1.42.0.tar.gz"
    sha256 "283ddc923e47857924fbef36580d2e98d984a47c962bae4cbce9c0ebcc98989c"
  end

  # The polars rust runtime crates require a pinned nightly Rust toolchain to
  # build from source (foldhash's "nightly" cargo feature is on by default), so
  # use the upstream abi3 wheels instead.
  resource "polars-runtime-32" do
    on_macos do
      on_arm do
        url "https://files.pythonhosted.org/packages/cf/72/06d3d78b7e8e8d3c72ea9eee310950334d50986462b3c1d40f82972495a5/polars_runtime_32-1.42.0-cp310-abi3-macosx_11_0_arm64.whl"
        sha256 "e7923db3bcb57e0edecde3be28629e0411414a15ef1a4c10c783ac5eadab2e1e"
      end
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/5a/77/20241aaf919a0f63b946fb702bc14447db290ef918e2c2943ed90d50fcc1/polars_runtime_32-1.42.0-cp310-abi3-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
        sha256 "42e27e2eb5909abcedb4ab4cc04ee67c5ec2b73a5640ebd8739b1b719383fa68"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/46/5c/ca14606a42628b04d82ac6ae5742ed24048bd43fbf48ae87fc4f4b9e759d/polars_runtime_32-1.42.0-cp310-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
        sha256 "1a3c43d4a76360bf912f8772b5ac1c23d5a8efef71408c63bba1bb0b4897a8ea"
      end
    end
  end

  resource "polars-runtime-compat" do
    on_macos do
      on_arm do
        url "https://files.pythonhosted.org/packages/dd/ae/a783f98a29b0072c26609bb80c55d704d322190c8f41f197a395cdfd3755/polars_runtime_compat-1.42.0-cp310-abi3-macosx_11_0_arm64.whl"
        sha256 "e222d00e196b22cd77123c01b714234fec4b7b57c8c0c4c6e91e3166c16195a2"
      end
    end
    on_linux do
      on_arm do
        url "https://files.pythonhosted.org/packages/e1/00/1a584f0918c040ab93bbd8049d6b824aaa826f6965be749de3459d50df69/polars_runtime_compat-1.42.0-cp310-abi3-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
        sha256 "3fdea4c5446e460db8d41a1c89ee2d797d766075e9cba7e9781ef6a38fe7b810"
      end
      on_intel do
        url "https://files.pythonhosted.org/packages/43/13/664bdf0ddef519f7e73d9493f04c9d9f4f52b2e72035561f9369725c0497/polars_runtime_compat-1.42.0-cp310-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
        sha256 "b588a112f8eb20539f43496fb62a23e13fc3501a921fbc9ebee3c697f93270e5"
      end
    end
  end

  # Installed from wheels: the pyarrow sdist build-requires the Arrow C++
  # libraries, which are not available in the sandbox.
  resource "pyarrow" do
    on_macos do
      url "https://files.pythonhosted.org/packages/6f/d3/a1abf004482026ddc17f4503db227787fa3cfe41ec5091ff20e4fea55e57/pyarrow-24.0.0-cp313-cp313-macosx_12_0_arm64.whl"
      sha256 "02b001b3ed4723caa44f6cd1af2d5c86aa2cf9971dacc2ffa55b21237713dfba"
    end
    on_linux do
      url "https://files.pythonhosted.org/packages/84/9f/8fb7c222b100d314137fa40ec050de56cd8c6d957d1cfff685ce72f15b17/pyarrow-24.0.0-cp313-cp313-manylinux_2_28_x86_64.whl"
      sha256 "6f066b179d68c413374294bc1735f68475457c933258df594443bb9d88ddc2a0"
    end
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/18/a5/b60d21ac674192f8ab0ba4e9fd860690f9b4a6e51ca5df118733b487d8d6/pydantic-2.13.4.tar.gz"
    sha256 "c40756b57adaa8b1efeeced5c196f3f3b7c435f90e84ea7f443901bec8099ef6"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/9d/56/921726b776ace8d8f5db44c4ef961006580d91dc52b803c489fafd1aa249/pydantic_core-2.46.4.tar.gz"
    sha256 "62f875393d7f270851f20523dd2e29f082bcc82292d66db2b64ea71f64b6e1c1"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/f7/ea/21e4867ea0ef881ffd4c0550fc21a061435e50d6324bcd034396633cbc18/rich_click-1.9.8.tar.gz"
    sha256 "4008f921da88b5d91646c134ec881c1500e5a6b3f093e90e8f29400e09608371"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/2e/43/25a8dcd3feedd735039a8f0b5b7e3b118232b5eae288c4fd9ab200d41094/rpds_py-2026.5.1.tar.gz"
    sha256 "07b24fea40541e28570e5b795a4a38fbdcd12550c06bd0748005ecc8116ca256"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/f6/94/dcdaeb1713cab9c84def276cfac7388b17c7d9855bbcfe88d77e4dbafd44/s3transfer-0.19.0.tar.gz"
    sha256 "ce436931687addc4c1712d52d40b32f53e88315723f107ffa20ba82b05a0f685"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "spectra" do
    url "https://files.pythonhosted.org/packages/68/1b/23c9c5c8f60fa8d5a4585448e958b6b68f4d69255f50d2d9c2f13b8bc8c1/spectra-0.1.0.tar.gz"
    sha256 "6a30e33241cb18256020395181cb4cc029dcac6de6f8d78cecbed81c14226a3f"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/e4/e5/5f3cb2159769d0f4324c0e9e87f9de3c4b1cd45848a96b2eb3566ad5ca77/tiktoken-0.13.0.tar.gz"
    sha256 "c9435714c3a84c2319499de9a300c0e604449dd0799ff246458b3bb6a7f433c1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/87/d7/0535a28b1f5f24f6612fb3ff1e89fb1a8d160fee0f976e0aa6803862134b/tqdm-4.68.3.tar.gz"
    sha256 "00dfa48452b6b6cfae3dd9885636c23d3422d1ec97c66d96818cbd5e0821d482"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/67/1c/dfba5c4633cafc4c701f237d2ba63b416805047fd6d96aab4cfc40969f98/typeguard-4.5.2.tar.gz"
    sha256 "5a16dcac23502039299c97c8941651bc33d7ea8cc4b2f7d6bbb1b528f6eea423"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/b9/d8/eab98a517c14134c0b2eb4e2387bc5f457334293ec5d2dd3857ec2966802/zipp-4.1.0.tar.gz"
    sha256 "4cb57381f544315db7688e976e922a2b18cdb513d21cc194eb42232ba2a3e602"
  end

  def install
    # Resources only published as platform-specific wheels: kaleido 0.2.1 has no
    # sdist, and the polars rust runtimes need a pinned nightly toolchain to
    # build from source. Install those as binaries; build everything else.
    wheel_resources = %w[kaleido polars-runtime-32 polars-runtime-compat pyarrow]

    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources.reject { |r| wheel_resources.include?(r.name) }

    # The venv is created with --without-pip, so drive installs through the
    # interpreter that backs the formula's "python3.13" dependency.
    python = formula_opt_libexec("python@3.13")/"bin/python"
    wheel_resources.each do |name|
      resource(name).stage do
        system python, "-m", "pip", "--python=#{libexec}/bin/python", "install",
               "--verbose", "--no-deps", "--ignore-installed", "--no-compile",
               Dir["*.whl"].first
      end
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multiqc --version")
  end
end
