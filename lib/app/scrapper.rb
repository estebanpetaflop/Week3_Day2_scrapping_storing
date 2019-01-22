#------------------------------------------------
#scrapping de mails du Val d'Oise

class Townhall
  attr_accessor :name, :email
  @@townhalls_hash = {}
  @@A={}

# méthode qui va chercher l'adresse mail à partir de l'URL
    def self.get_townhall_email(townhall_url)
      page = Nokogiri::HTML(open(townhall_url))
      page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').each do |node|
        return node.text
        end
      end

# méthode qui va chercer tous les urls et qui petit à petit stocke toutes les infos dans un array
    def self.get_townhall_urls ()
      page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
        page.xpath("//tr[2]//p/a").each do |node|
          @name = node.text
          @email = get_townhall_email("http://annuaire-des-mairies.com/"+node["href"])
          @@townhalls_hash[@name] = @email
          end
          return @@townhalls_hash
      end

# Je crée un self.all pour pouvoir faire un Townhall.all comme lundi

      def self.all
        return Townhall.get_townhall_urls
      end

#on crée le json et on écrit chaque objet (hash) dans le json à la ligne
      def self.save_as_JSON
              File.open("db/emails.json","w") do |f|
              f.write(JSON.pretty_generate(Townhall.all))
          end
          puts "JSON ready"
      end


# création du Spreadsheet
def self.save_as_spreadsheet
      # Creation de la session
      session = GoogleDrive::Session.from_config("config.json")
      # On va choper le spreadsheets créé à la mano
      ws = session.spreadsheet_by_key("1SO8tZ_0QVztgJt_BRXz5GvAgA4k0HrbSvTjkHjfkK6g").worksheets[0]
      # On crée le header
      ws[1, 1] = "Ville"
      ws[1, 2] = "Email"
      # Fonction magique Update.cells qui lit un array de array
      ws.update_cells(2,1,Townhall.all.to_a)
      ws.save
    end


# création du CSV
  def self.save_as_csv
      # table = CSV.parse("db/emails.csv",headers: true)
      # @@A.merge({ "VILLE" => "email" })
      # @@A.merge(Townhall.all)
      CSV.open("db/emails.csv","w") do |csv|
            Townhall.all.each do |el|
            csv << el
          end
      end
      # puts "CSV Ready"
  end


end
