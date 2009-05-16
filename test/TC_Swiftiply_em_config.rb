require 'test/unit'
require 'external/test_support'
SwiftcoreTestSupport.set_src_dir
require 'swiftcore/Swiftiply'
require 'mocha'

class TC_Swiftiply_em_config < Test::Unit::TestCase
	def setup
		@server_mock = :server
		EventMachine.stubs(:start_server).returns(@server_mock)
		EventMachine.stubs(:add_periodic_timer)
		@default_config = { "cluster_address" => "127.1.2.3", "cluster_port" => 35768, "map" => [] }
	end

	def test_em_config
		configuration = Swiftcore::Swiftiply::em_config(@default_config)
		assert_equal(@server_mock, configuration["cluster_server"]["#{@default_config["cluster_address"]}:#{@default_config["cluster_port"]}"])
		assert_equal(true, configuration[:initialized])
	end

	def test_em_config_server_unavailable_timeout_default
		EventMachine.stubs(:start_server)
		EventMachine.stubs(:add_periodic_timer)
		configuration = Swiftcore::Swiftiply::em_config(@default_config)
		assert_equal(6, Swiftcore::Swiftiply::ProxyBag.server_unavailable_timeout)
	end

	def test_em_config_override_server_unavailable_timeout
		EventMachine.stubs(:start_server)
		EventMachine.stubs(:add_periodic_timer)
		something = Swiftcore::Swiftiply::em_config(@default_config.merge("timeout" => 23))
		assert_equal(23, Swiftcore::Swiftiply::ProxyBag.server_unavailable_timeout, "server_unavailable_timeout could not be set")
	end
end