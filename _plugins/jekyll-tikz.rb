module Jekyll
    module Tags
      class Tikz < Liquid::Block
        def initialize(tag_name, markup, tokens)
          super  
        end
  
        def render(context)
          content = super.strip

          <<~HTML
            <div class="tikz-wrapper">
            <script type="text/tikz">
              #{content}
            </script>
            </div>
          HTML
        end
  
      end
    end
  end
  
  Liquid::Template.register_tag('tikz', Jekyll::Tags::Tikz)