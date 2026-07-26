class GitHubPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  require "net/http"
  require "json"

  def initialize(url, name, version, **meta)
    super
    @github_token = ENV["HOMEBREW_GITHUB_API_TOKEN"]
    raise CurlDownloadStrategyError, "HOMEBREW_GITHUB_API_TOKEN is required." unless @github_token

    url_pattern = %r{https://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/([^/]+)\z}
    raise CurlDownloadStrategyError, "Invalid GitHub release URL: #{@url}" unless @url =~ url_pattern

    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)

    @url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{fetch_asset_id}"
    @meta[:headers] ||= []
    @meta[:headers] << "Authorization: token #{@github_token}"
    @meta[:headers] << "Accept: application/octet-stream"
  end

  private

  def fetch_asset_id
    uri = URI("https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}")
    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "token #{@github_token}"
    req["Accept"] = "application/vnd.github+json"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    raise CurlDownloadStrategyError, "GitHub API error #{response.code} for #{@owner}/#{@repo}" unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    asset = data["assets"]&.find { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError, "Asset #{@filename} not found in release #{@tag}." unless asset

    asset["id"]
  end
end

class Minions < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Minions serverless AI agent framework"
  homepage "https://github.com/greenlsi/minions"
  url "https://github.com/greenlsi/minions/releases/download/v0.2.2/minions-0.2.2.tar.gz",
      using: GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "b7c558ce87975140a54e8f297b28849f306a71d9634aae5aba3d60e902deb25b"
  license "LicenseRef-Proprietary"

  depends_on "python@3.13"
  depends_on "rust" => :build

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/66/a2/d31f14e28d49bae983a3634e38dfb4b31c50110b5e403596c5c6a20b23f8/anthropic-0.116.0.tar.gz"
    sha256 "5fc248fbb9fe03ef686f8a774f81586bca31a043260aab88b387ea3660f4a396"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/3b/72/5562aabb8dd7181e8e860622a38bea08d17842b99ecd4c91f84ac95251b0/anyio-4.14.1.tar.gz"
    sha256 "8d648a3544c1a700e3ff78615cd679e4c5c3f149904287e73687b2596963629e"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/3b/43/38cdaf9c7bb50f0922ef87e6b6696c6aa589d978e4311a8287537e84ecf7/boto3-1.43.40.tar.gz"
    sha256 "a7108b9ce25b8f92d1ce96b9e35090794d5c58b219ff2f6a7a65c8986a4ed6f4"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d0/50/269986277f852cc83029bccbdcdc0b343a685cfd570599e58029792808d8/botocore-1.43.40.tar.gz"
    sha256 "2085a4314cfd2c8bc1d08ab8039f76c92e99278db0d2a0e2437010526d5d5d70"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c9/c7/424b75da314c1045981bd9777432fad05a9e0c69daa4ed7e308bbaffe405/certifi-2026.6.17.tar.gz"
    sha256 "024c88eeec92ca068db80f02b8b07c9cef7b9fe261d1d535abfd5abd6f6af432"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/1f/99/d1c90d6041656cc6ee229dc99cd67fd0cd5aec3c5f7d72fffc27cc750054/cryptography-49.0.0.tar.gz"
    sha256 "f89660a348f4f78a92366240a61404e337586ef7f5909a2fef59ca88ef505493"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/e0/4d/f332313098c1de1b2d2ff91cf2674415cc7cddab2ca1b01ae29774bd5fdf/docstring_parser-0.18.0.tar.gz"
    sha256 "292510982205c12b1248696f44959db3cdd1740237a968ea1e2e7a900eeb2015"
  end

  resource "google-ai-generativelanguage" do
    url "https://files.pythonhosted.org/packages/11/d1/48fe5d7a43d278e9f6b5ada810b0a3530bbeac7ed7fcbcd366f932f05316/google_ai_generativelanguage-0.6.15.tar.gz"
    sha256 "8f6d9dc4c12b065fe2d0289026171acea5183ebf2d0b11cefe12f3821e159ec3"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/c6/22/155cadf1d49272a9cf48f3168c0f3874fa13397297e611a5ea00cd093880/google_api_core-2.31.0.tar.gz"
    sha256 "2be84ee0f584c48e6bde1b36766e23348b361fb7e55e56135fc76ce1c397f9c2"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/6b/53/0cd38e3a29d72ce45e27feba2ce1cd8049d69af9c48cb14fb164f1be9133/google_api_python_client-2.198.0.tar.gz"
    sha256 "dfe3e16fb241af6e9c460a33f65085b3450e05cea09364f6b5d8997fb7e43e2a"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/a3/6f/f3f4ac177c67bbee8fe8e88f2ab4f36af88c44a096e165c5217accf6e5d3/google_auth-2.55.1.tar.gz"
    sha256 "fb2d9b730f2c9b8d326ec8d7222f21aef2ead15bf0513793d6442485d87af0a1"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/1c/b3/f192c8bc7e41e0ebdbd95afcae4783417a34b6a6af62d22daf22c3fd38fc/google_auth_httplib2-0.4.0.tar.gz"
    sha256 "d5b030a204b7a4b4d553ba9ca701b62481ee2b74419325580be70f7d85ffed35"
  end

  resource "google-generativeai" do
    url "https://files.pythonhosted.org/packages/97/0f/ef33b5bb71437966590c6297104c81051feae95d54b11ece08533ef937d3/google_generativeai-0.8.6-py3-none-any.whl"
    sha256 "37a0eaaa95e5bbf888828e20a4a1b2c196cc9527d194706e58a68ff388aeb0fa"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
  end

  resource "groq" do
    url "https://files.pythonhosted.org/packages/0b/3a/31c54e35d694ba9c263939ecae0874c78fc51f22b9fb13d2dab50edf6e3c/groq-1.5.0.tar.gz"
    sha256 "8648388f8668629490bb0eab11252b4cc43316149fda9c6343e9a9577fe7df88"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/b0/b5/1ff353970a87eda4c98251e34d2dfd214abd4982dc89119c9252a2a482d2/grpcio-1.81.1.tar.gz"
    sha256 "6fa10a767143a5e82e8eaab53918af0cd8909a57a27f8cb2288b80a613ac671b"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/fd/d1/b6e9877fedae3add1afdeae1f89d1927d296da9cf977eca0eb08fb8a460e/grpcio_status-1.71.2.tar.gz"
    sha256 "c7a97e176df71cdc2c179cd1847d7fc86cca5832ad12e9798d7fed6b7a1aab50"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/84/f5/ccf58de92d61e3ad921119668f54ed36ca1d0cf5dcc5c1657dfb164fd78b/httplib2-0.32.0.tar.gz"
    sha256 "48a0ef30a42db65d8f3399045e1d09ab0ba66e3b9efc360d07f80ea55d286025"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco.context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco.functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/1d/1f/10936e16d8860c70698a1aa939a46aa0224813b782bce4e000e637da0b2d/jiter-0.16.0.tar.gz"
    sha256 "7b24c3492c5f4f84a37946ad9cf504910cf6a782d6a4e0689b6673c5894b4a1c"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/49/f5/7c7cb955305cb41f7f3c5fd7e0e38bf6bbf2658468863d4b7b868a5cb8df/openai-2.44.0.tar.gz"
    sha256 "68a5a5ffad82b8ff7d451c437529fb64f7c3b8123aaf0c021966a882d9e3947d"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/c9/56/e647b0c675392d2da368da7b6f158f7368b18542fd6f7d7400a2f39de000/proto_plus-1.28.0.tar.gz"
    sha256 "38e5696342835b08fc116f30a25665b29531cda9d5d5643e9b81fc312385abd9"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/7e/57/394a763c103e0edf87f0938dafcd918d53b4c011dfc5c8ae80f3b0452dbb/protobuf-5.29.6.tar.gz"
    sha256 "da9ee6a5424b6b30fd5e45c5ea663aef540ca95f9ad99d1e887e819cdf9b8723"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/18/a5/b60d21ac674192f8ab0ba4e9fd860690f9b4a6e51ca5df118733b487d8d6/pydantic-2.13.4.tar.gz"
    sha256 "c40756b57adaa8b1efeeced5c196f3f3b7c435f90e84ea7f443901bec8099ef6"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/9d/56/921726b776ace8d8f5db44c4ef961006580d91dc52b803c489fafd1aa249/pydantic_core-2.46.4.tar.gz"
    sha256 "62f875393d7f270851f20523dd2e29f082bcc82292d66db2b64ea71f64b6e1c1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-frontmatter" do
    url "https://files.pythonhosted.org/packages/9d/e8/79cbe69864d44f3b48e70ebee0a872a7d5a4e7150c9f8577ed7a5beefff0/python_frontmatter-1.3.0.tar.gz"
    sha256 "acc73e477a568dc2a25c9e130c6c68ae8daa8c204c8f7e813db47d6a7280dcf2"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/f6/94/dcdaeb1713cab9c84def276cfac7388b17c7d9855bbcfe88d77e4dbafd44/s3transfer-0.19.0.tar.gz"
    sha256 "ce436931687addc4c1712d52d40b32f53e88315723f107ffa20ba82b05a0f685"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/5e/89/b4a0bcfdf4f71a3dea31379f095929613d7e4528a0996bca6aa964cd0dca/structlog-26.1.0.tar.gz"
    sha256 "f63a716cbd1b1291cf7661de7794b455acfa4c43c5bcf1630e6ad5ddc1adb3b7"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/87/d7/0535a28b1f5f24f6612fb3ff1e89fb1a8d160fee0f976e0aa6803862134b/tqdm-4.68.3.tar.gz"
    sha256 "00dfa48452b6b6cfae3dd9885636c23d3422d1ec97c66d96818cbd5e0821d482"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output("#{bin}/minions --help")
  end
end
