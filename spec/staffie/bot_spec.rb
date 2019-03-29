# frozen_string_literal: true

require 'spec_helper'

describe Staffie::Bot do
  def app
    Staffie::Bot.instance
  end

  subject { app }

  it_behaves_like 'a slack ruby bot'
end
