module Magenthor
    class Customer < Base
        
        attr_accessor :firstname, :lastname, :middlename, :increment_id, :store_id, 
                    :website_id, :created_in, :email, :group_id, :prefix, :suffix, :dob,
                    :taxvat, :confirmation, :gender
        attr_reader :customer_id, :increment_id, :created_at, :updated_at, :password_hash
        
        private
        attr_writer :customer_id, :increment_id, :created_at, :updated_at, :password_hash
        
        public
        
        def initialize params = {}
            binding.pry
            params.each do |k, v|
                send("#{k}=", v) if respond_to? "#{k}="
            end
            self.customer_id = params["customer_id"]
            self.increment_id = params["increment_id"]
            self.created_at = params["created_at"]
            self.updated_at = params["updated_at"]
            self.password_hash = params["password_hash"]
            
        end
        
        class << self
            #TODO: better description
            #List al customers with all info
            def list filters = []
                response = commit('customer.list', filters)
                customers = []
                response.each do |r|
                    customers << find(r["customer_id"])
                end
                return customers
            end
            
            #TODO: better description
            #Find a customer by id
            def find customer_id
                response = commit('customer.info', [customer_id])
                new(response) unless response == false
            end
            
            #TODO: better description
            #Dynamic methods to find customers based on Magento attributes
            customer_attributes = [
                "increment_id",
                "created_in",
                "store_id",
                "website_id",
                "email",
                "firstname",
                "middlename",
                "lastname",
                "group_id",
                "prefix",
                "suffix",
                "dob",
                "taxvat",
                "confirmation"]
            customer_attributes.each do |a|
                define_method("find_by_#{a}") do |arg|
                    find_by a, arg
                end
            end
            
            #TODO: better description
            #Create a new customer on Magento
            def create attributes
                commit('customer.create', attributes)
            end
            
            
            private
            
            #TODO: better description
            #Method to find customers based on a specific Magento attribute
            def find_by (attribute, value)
                response = commit('customer.info', [attribute => value])
                new(response) unless response == false
            end
        end
    end
end