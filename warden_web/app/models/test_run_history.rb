class TestRunHistory < ActiveRecord::Base
  attr_accessible :is_last_run, :run_sequence
end
