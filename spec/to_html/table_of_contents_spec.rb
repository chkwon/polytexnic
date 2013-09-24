# encoding=utf-8
require 'spec_helper'

describe 'Polytexnic::Core::Pipeline#to_html' do

  let(:processed_text) { Polytexnic::Core::Pipeline.new(polytex).to_html }
  subject { processed_text }

  describe '\chapter' do
    let(:polytex) do <<-'EOS'
        \tableofcontents
        \chapter{Foo}
        \label{cha:foo}

        \section{Bar}
        \label{sec:bar}

        \subsection{Baz}
        \label{sec:baz}

        \subsubsection{Null}
        \label{sec:null}

        \section{Quux}
        \label{sec:quux}

        \chapter{Lorem}
        \label{cha:lorem}

      EOS
    end

    let(:output) do <<-'EOS'
<div id="table_of_contents">
  <ul><li class="chapter">
      <a href="#cha-foo" class="heading"><span class="number">Chapter 1 </span>Foo</a>
    </li>
    <ul><li class="section">
        <a href="#sec-bar" class="heading"><span class="number">1.1 </span>Bar</a>
      </li>
      <ul><li class="subsection">
          <a href="#sec-baz" class="heading"><span class="number">1.1.1 </span>Baz</a>
        </li>
        <ul><li class="subsubsection">
            <a href="#sec-null" class="heading"><span class="number">1.1.1.1 </span>Null</a>
          </li>
        </ul></ul></ul><ul><li class="section">
        <a href="#sec-quux" class="heading"><span class="number">1.2 </span>Quux</a>
      </li>
    </ul></ul><ul><li class="chapter">
      <a href="#cha-lorem" class="heading"><span class="number">Chapter 2 </span>Lorem</a>
    </li>
  </ul></div>
      EOS
    end

    subject(:toc) do
      Nokogiri::HTML(processed_text).css('div#table_of_contents')
    end

    it { should_not be_empty }

    it "should have a 'depth' attribute" do
      expect(toc.first['depth']).to be_nil
    end

    it "should have a link to the first chapter" do
      expect(toc.css('li>a')[0]['href']).to eq '#cha-foo'
    end

    it "should have a link to the first section" do
      expect(toc.css('li>a')[1]['href']).to eq '#sec-bar'
    end

    it "should have a link to the first subsection" do
      expect(toc.css('li>a')[2]['href']).to eq '#sec-baz'
    end

    it "should have a link to the first subsubsection" do
      expect(toc.css('li>a')[3]['href']).to eq '#sec-null'
    end

    it "should have a link to the second section" do
      expect(toc.css('li>a')[4]['href']).to eq '#sec-quux'
    end

    it "should have a link to the second chapter" do
      expect(toc.css('li>a')[5]['href']).to eq '#cha-lorem'
    end

    it "should have the right number of lists" do
      expect(toc.css('ul').length).to eq 6
    end

    its(:to_xhtml) { should resemble output }
  end
end