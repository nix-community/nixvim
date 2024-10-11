{
	empty = {
		# don't run tests as they try to access the network.
		test.runNvim = false;
		plugins.cord-nvim.enable = true;
	};

	defaults = {
		# don't run tests as they try to access the network.
		test.runNvim = true;
		plugins.cord-nvim = {
			enable = true;
			settings = {
				usercmd = false;
				log_level = null;
			};
		};
	};

	example = {
		# don't run tests as they try to access the network.
		test.runNvim = false;
		plugins.cord-nvim = {
			enable = true;
			settings = {
				usercmd = false;
			};
		};
	};
}
