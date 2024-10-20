class Ntsynt < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang
  # cite Coombe_2024: "https://doi.org/10.1101/2024.02.07.579356"
  desc "Detecting multi-genome synteny using minimizer graph mapping"
  homepage "https://github.com/bcgsc/ntSynt"
  url "https://github.com/bcgsc/ntSynt.git",
  tag:      "v1.0.2",
  revision: "f7e358fb1b58e7a1c33f3a876a29214e185c5dde"
  license "GPL-3.0-or-later"
  head "https://github.com/bcgsc/ntSynt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "3d33550be2b8c7285daace3d11c15ce36017484848d1c01c91bc5fae2c5af51c"
    sha256 cellar: :any,                 ventura:      "502dc7cedad7c31045435975c34046f4a7b269329b071804a19a598c170d0bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2df7654b98427724b552f43eaaf83dc800e4c6e0454849d43715039811ed1ee3"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "pigz" => :test
  depends_on "bedtools"
  depends_on "brewsci/bio/btllib"
  depends_on "cbc"
  depends_on "certifi"
  depends_on "cython"
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "samtools"
  depends_on "seqtk"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argparse-dataclass" do
    url "https://files.pythonhosted.org/packages/1a/ff/a2e4e328075ddef2ac3c9431eb12247e4ba707a70324894f1e6b4f43c286/argparse_dataclass-2.0.0.tar.gz"
    sha256 "09ab641c914a2f12882337b9c3e5086196dbf2ee6bf0ef67895c74002cc9297f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b0/ee/9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1/certifi-2024.8.30.tar.gz"
    sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "conda-inject" do
    url "https://files.pythonhosted.org/packages/b1/a8/8dc86113c65c949cc72d651461d6e4c544b3302a85ed14a5298829e6a419/conda_inject-1.3.2.tar.gz"
    sha256 "0b8cde8c47998c118d8ff285a04977a3abcf734caf579c520fca469df1cd0aac"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "connection-pool" do
    url "https://files.pythonhosted.org/packages/bd/df/c9b4e25dce00f6349fd28aadba7b6c3f7431cc8bd4308a158fbe57b6a22e/connection_pool-0.0.3.tar.gz"
    sha256 "bf429e7aef65921c69b4ed48f3d48d3eac1383b05d2df91884705842d974d0dc"
  end

  resource "datrie" do
    url "https://files.pythonhosted.org/packages/9d/fe/db74bd405d515f06657f11ad529878fd389576dca4812bea6f98d9b31574/datrie-0.8.2.tar.gz"
    sha256 "525b08f638d5cf6115df6ccd818e5a01298cd230b2dac91c8ff2e6499d18765d"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/b5/ce/e1fd64d36e4a5717bd5e6b2ad188f5eaa2e902fde871ea73a79875793fc9/dpath-2.2.0.tar.gz"
    sha256 "34f7e630dc55ea3f219e555726f5da4b4b25f2200319c8e6902c394258dd6a3e"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/03/3f/3ad5e7be13b4b8b55f4477141885ab2364f65d5f6ad5f7a9daffd634d066/fastjsonschema-2.20.0.tar.gz"
    sha256 "3d48fc5300ee96f5d116f10fe6f28d938e6008f59a6a025c2649475b87f76a23"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/b6/a1/106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662/GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/e8/ac/e349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72a/idna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "igraph" do
    url "https://files.pythonhosted.org/packages/5f/a0/1f70c34a96dcb0acf428319e83655e92ab2955d73a33f711852a5fb79681/igraph-0.11.6.tar.gz"
    sha256 "837f233256c3319f2a35a6a80d94eafe47b43791ef4c6f9e9871061341ac8e28"
  end

  resource "immutables" do
    url "https://files.pythonhosted.org/packages/7d/63/27f038a28ff2110bc04908a047817fd316d5a16ae06d0d3707732dee8013/immutables-0.20.tar.gz"
    sha256 "1d2f83e6a6a8455466cd97b9a90e2b4f7864648616dfa6b19d18f49badac3876"
  end

  resource "intervaltree" do
    url "https://files.pythonhosted.org/packages/50/fb/396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bb/intervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/00/11/b56381fa6c3f4cc5d2cf54a7dbf98ad9aa0b339ef7a601d6053538b079a7/jupyter_core-5.7.2.tar.gz"
    sha256 "aa5f8d32bbf6b431ac830496da7392035d6f61b4f54872f15c4bd2a9c3f536d9"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/6d/fd/91545e604bc3dad7dca9ed03284086039b294c6b3d75c0d2fa45f9e9caf3/nbformat-5.10.4.tar.gz"
    sha256 "322168b14f937a5d11362988ecac2a4952d3d8e3a2cbeb2319584631226d5b3a"
  end

  resource "ncls" do
    url "https://files.pythonhosted.org/packages/88/b8/210d5cb1fa85c7675323aacbd52af11553dc190aad1c15584699f40797f1/ncls-0.0.68.tar.gz"
    sha256 "81aaa5abb123bb21797ed2f8ef921e20222db14a3ecbc61ccf447532f2b7ba93"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "plac" do
    url "https://files.pythonhosted.org/packages/9b/79/1edb4c836c69306d0ecb0865f46d62ea7e28ef16b3f95bb394e4f2a46330/plac-1.4.3.tar.gz"
    sha256 "d4cb3387b2113a28aebd509433d0264a4e5d9bb7c1a86db4fbd0a8f11af74eb3"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "PuLP" do
    url "https://files.pythonhosted.org/packages/2c/e0/683a36567b0a396961192dc9ec477ba1f88be56d968ca26688bd6e02f23b/PuLP-2.8.0.tar.gz"
    sha256 "4903bf96110bbab8ed2c68533f90565ebb76aa367d9e4df38e51bf727927c125"
  end

  resource "pybedtools" do
    url "https://files.pythonhosted.org/packages/cc/90/cea4197772a029e925bd5d414108b5438d621dfbb1b0cc2627529d1ec524/pybedtools-0.10.0.tar.gz"
    sha256 "1a6fbaad23b013becc741d7d5922a2df03e391bc44ff92772ffb7dd456711161"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/a6/bc/e0a79d74137643940f5406121039d1272f29f55c5330e7b43484b2259da5/pysam-0.22.1.tar.gz"
    sha256 "18a0b97be95bd71e584de698441c46651cdff378db1c9a4fb3f541e560253b22"
  end

  resource "python-igraph" do
    url "https://files.pythonhosted.org/packages/6c/2e/20056de5fa65dcfea06ea7e540880105f39b2d92741248c42f84503bad09/python_igraph-0.11.6.tar.gz"
    sha256 "8cdda8bc36be9498614f4a7ccb1ebc0b83d8e24069abef8e932a979476e7930b"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "reretry" do
    url "https://files.pythonhosted.org/packages/40/1d/25d562a62b7471616bccd7c15a7533062eb383927e68667bf331db990415/reretry-0.11.8.tar.gz"
    sha256 "f2791fcebe512ea2f1d153a2874778523a8064860b591cd90afc21a8bed432e3"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "smart-open" do
    url "https://files.pythonhosted.org/packages/06/84/c6e6276a72a78996f11118b8bc1d9e9b619aa78201f408210f4a584bd377/smart_open-7.0.4.tar.gz"
    sha256 "62b65852bdd1d1d516839fcb1f6bc50cd0f16e05b4ec44b52f43d38bcb838524"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "snakemake" do
    url "https://files.pythonhosted.org/packages/f6/6a/6bed45f9c2612fb8144974b68f4af0918aad53394433aa7fd19d7459131a/snakemake-8.19.0.tar.gz"
    sha256 "b99e034846a71d125b709f73f2a878bb7b3ba4af8b573b1bd7cafa738a020f44"
  end

  resource "snakemake-interface-common" do
    url "https://files.pythonhosted.org/packages/9c/50/f90165066f14f816729f93104c1361cd14d7903cdaa3b7bbebb6ecacafe2/snakemake_interface_common-1.17.3.tar.gz"
    sha256 "cca6e2c728072a285a8e750f00fdd98d9c50063912184c41f8b89e4cab66c7b0"
  end

  resource "snakemake-interface-executor-plugins" do
    url "https://files.pythonhosted.org/packages/b5/a4/b07c112db129f5d2471a09dea59b472e707014b460e4ad52419cd0690c64/snakemake_interface_executor_plugins-9.2.0.tar.gz"
    sha256 "67feaf438a0b8b041ec5f1a1dd859f729036c70c07c9fdad895135f5b949e40a"
  end

  resource "snakemake-interface-report-plugins" do
    url "https://files.pythonhosted.org/packages/ea/49/8ef5e80fabce98f44767cf3a30656348806df9759db26e5a2fda59700f9b/snakemake_interface_report_plugins-1.0.0.tar.gz"
    sha256 "02311cdc4bebab2a1c28469b5e6d5c6ac6e9c66998ad4e4b3229f1472127490f"
  end

  resource "snakemake-interface-storage-plugins" do
    url "https://files.pythonhosted.org/packages/c7/7d/f5d9662f97121cc42415197bacccb7a1cc893524da1138c2fc19ef835881/snakemake_interface_storage_plugins-3.3.0.tar.gz"
    sha256 "203d8f794dfb37d568ad01a6c375fa8beac36df8e488c0f9b9f75984769c362a"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "stopit" do
    url "https://files.pythonhosted.org/packages/35/58/e8bb0b0fb05baf07bbac1450c447d753da65f9701f551dca79823ce15d50/stopit-1.1.2.tar.gz"
    sha256 "f7f39c583fd92027bd9d06127b259aee7a5b7945c1f1fa56263811e1e766996d"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "throttler" do
    url "https://files.pythonhosted.org/packages/b4/22/638451122136d5280bc477c8075ea448b9ebdfbd319f0f120edaecea2038/throttler-1.2.2.tar.gz"
    sha256 "d54db406d98e1b54d18a9ba2b31ab9f093ac64a0a59d730c1cf7bb1cdfc94a58"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/69/19/8e955d90985ecbd3b9adb2a759753a6840da2dff3c569d412b2c9217678b/toposort-1.10.tar.gz"
    sha256 "bfbb479c53d0a696ea7402601f4e693c97b0367837c8898bc6471adfca37a6bd"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/eb/79/72064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574/traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "yte" do
    url "https://files.pythonhosted.org/packages/58/4b/3f89f96417e4e39c3f3e3f4a17d6233e81dc1e5cd5b5ed0a2498faedf690/yte-1.5.4.tar.gz"
    sha256 "d2d77e53eafca74f58234fcd3fea28cc0a719e4f3784911511e35e86594bc880"
  end

  def python3
    which("python3.13")
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    # Remove the bundled CBC solver (Ref: homebrew-core/Formula/snakemake.rb)
    rm_r(venv.site_packages/"pulp/solverdir/cbc")
    # Use venv's python3 and snakemake
    inreplace "bin/ntsynt_run_pipeline.smk",
              "python3 {params.path_to_script}",
              "#{venv.root}/bin/python3 {params.path_to_script}"
    inreplace "bin/ntSynt",
              "snakemake -s", "#{venv.root}/bin/snakemake -s"
    inreplace "bin/meson.build", "install_dir : 'bin'", "install_dir : 'libexec'"
    inreplace "scripts/install-ntjoin", "${MESON_INSTALL_PREFIX}/bin",
                                        "${MESON_INSTALL_PREFIX}/libexec"
    # pkg_resources is deprecated in Python 3.13
    inreplace libexec/"lib/python3.13/site-packages/wrapt/importer.py" do |s|
      s.gsub! "import pkg_resources",
              "group_entry_points = importlib.metadata.entry_points().get(group, [])"
      s.gsub! "pkg_resources.iter_entry_points(group=group)",
              "group_entry_points"
    end
    inreplace libexec/"lib/python3.13/site-packages/ncls/__init__.py" do |s|
      s.gsub! "import pkg_resources",
              "import importlib.metadata"
      s.gsub! "pkg_resources.get_distribution(\"ncls\").version",
              "importlib.metadata.version(\"ncls\")"
    end
    inreplace libexec/"lib/python3.13/site-packages/stopit/__init__.py" do |s|
      s.gsub! "import pkg_resources",
              "import importlib.metadata"
      s.gsub! "pkg_resources.get_distribution(__name__).version",
              "importlib.metadata.version(__name__)"
    end

    system "meson", "setup", "build", "--prefix", prefix, "--bindir", libexec
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    libexec.install "analysis_scripts/denovo_synteny_block_stats.py"
    chmod 0555, libexec/"denovo_synteny_block_stats.py"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *libexec.children
    bin.install_symlink libexec/"ntSynt", libexec/"denovo_synteny_block_stats.py"
    prefix.install "tests"
    prefix.install "visualization_scripts"
  end

  def caveats
    <<~EOS
      The visualization scripts are available in:
        #{prefix}/visualization_scripts
    EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/denovo_synteny_block_stats.py -h")
    assert_match "usage", shell_output("#{bin}/ntSynt -h")
    cp_r prefix/"tests", testpath
    cd "tests" do
      assert_match "Compare your output files", shell_output("bash run_ntSynt_demo.sh")
    end
  end
end
