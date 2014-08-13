require "lita"

module Lita
  module Handlers
    class Memegen < Handler

      def self.default_config(config)
        config.command_only = true
        config.username = nil
        config.password = nil
      end

      route %r{(Y U NO) (.+)}i,                                    :meme_y_u_no,           help: { "Y U NO..." => "generates Y U NO meme"}
      route %r{(I DON'?T ALWAYS .*) (BUT WHEN I DO,? .*)}i,        :meme_i_dont_always,    help: { "I DON'T ALWAYS .. BUT WHEN I DO, .." => "generates I DON'T ALWAY meme"}
      route %r{(.*)(SUCCESS|NAILED IT.*)},                         :meme_success,          help: { "..SUCCESS.." => "(case sensitive) generates SUCCESS meme", "..NAILED IT.." => "generates NAILED IT meme" }
      route %r{(.*) (ALL the .*)},                                 :meme_all_the,          help: { "ALL the.." => "(case sensitive) generates ALL the <things> meme" }
      route %r{(.*) (\w+\sTOO DAMN .*)}i,                          :meme_too_damn,         help: { "TOO DAMN.." => "generates TOO DAMN meme" }
      route %r{(NOT SURE IF .*) (OR .*)}i,                         :meme_not_sure_if,      help: { "NOT SURE IF.. OR.." => "generates NOT SURE IF .. OR meme" }
      route %r{(YO DAWG .*) (SO .*)}i,                             :meme_yo_dawg,          help: { "YO DAWG.." => "generates YO DAWG meme" }
      route %r{(.*) (You'?re gonna have a bad time)}i,             :meme_bad_time,         help: { ".. You're going have a bad time" => "generates You're gonna have a bad time meme" }
      route %r{(one does not simply) (.*)}i,                       :meme_simply,           help: { "one does not simply.." => "generates one does not simply.. meme" }
      route %r{(grumpy cat) (.*),(.*)}i,                           :meme_grumpy_cat,       help: { "grumpy cat .. , .." => "generates grumpy cat .. , .. meme" }
      route %r{(AM I THE ONLY ONE AROUND HERE) (.*)}i,             :meme_am_i_only,        help: { "AM I THE ONLY ONE AROUND HERE.." => "generates AM I THE ONLY ONE AROUND HERE.. meme" }
      route %r{(BRACE YOURSELF|BRACE YOURSELVES) (.*)}i,                      :meme_brace_yourselves, help: { "BRACE YOURSELVES.." => "generates BRACE YOURSELVES.. meme" }
      route %r{(WHAT IF I TOLD YOU) (.*)}i,                        :meme_what_if_i,        help: { "WHAT IF I TOLD YOU.." => "generates WHAT IF I TOLD YOU.. meme" }

      def meme_y_u_no(response)
        generate_meme(response, 61527)
      end

      def meme_i_dont_always(response)
        generate_meme(response, 61532)
      end

      def meme_success(response)
        generate_meme(response, 61544)
      end

      def meme_all_the(response)
        generate_meme(response, 61533)
      end

      def meme_too_damn(response)
        generate_meme(response, 61580)
      end

      def meme_not_sure_if(response)
        generate_meme(response, 61520)
      end

      def meme_yo_dawg(response)
        generate_meme(response, 101716)
      end

      def meme_bad_time(response)
        generate_meme(response, 100951)
      end

      def meme_simply(response)
        generate_meme(response, 61579)
      end

      def meme_grumpy_cat(response)
        generate_meme(response, 405658)
      end

      def meme_am_i_only(response)
        generate_meme(response, 259680)
      end

      def meme_brace_yourselves(response)
        generate_meme(response, 61546)
      end

      def meme_what_if_i(response)
        generate_meme(response, 100947)
      end

      private

      def generate_meme(response, template_id, line1: nil, line2: nil)
        return if Lita.config.handlers.memegen.command_only && !response.message.command?

        line1 ||= response.matches[0][0]
        line2 ||= response.matches[0][1]
        return if Lita.config.handlers.memegen.username.nil? || Lita.config.handlers.memegen.password.nil?

        http_resp = http.post(
          'https://api.imgflip.com/caption_image',
          username: Lita.config.handlers.memegen.username,
          password: Lita.config.handlers.memegen.password,
          template_id: template_id,
          text0: line1,
          text1: line2
          )

        if http_resp.status == 200
          data = MultiJson.load(http_resp.body)

          if data['success']
            response.reply data['data']['url']
          else
            Lita.logger.error "#{self.class}: Unable to generate a meme image: #{data.inspect}"
            response.reply "Error: Unable to generate a meme image"
          end

        else
          Lita.logger.error "#{self.class}: Unable to generate a meme image: #{http_resp.body}"
          response.reply "Error: Unable to generate a meme image"
        end

      end

    end

    Lita.register_handler(Memegen)
  end
end
