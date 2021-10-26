require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')

class Customer < ActiveRecord::Base

  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.
  #anyone with first name Candice
  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    return Customer.where(first: :'Candice')
  end
  #with valid email (email addr contains "@") (HINT: look up SQL LIKE operator)
  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    return Customer.where("email like '%@%'")
  end
  # etc. - see README.md for more details
  #with .org emails
  def self.with_dot_org_email
    return Customer.where("email like '%@%.org'")
  end
  #with invalid but nonblank email (does not contain "@")
  def self.with_invalid_email
    return Customer.where("email not like '%@%'")
  end
  #with blank email
  def self.with_blank_email
    return Customer.where("email is null")
  end
  #born before 1 Jan 1980
  def self.born_before_1980
    return Customer.where('birthdate < ?','1980-01-01')
  end
  #with valid email AND born before 1/1/1980
  def self.with_valid_email_and_born_before_1980
    return Customer.where("email like '%@%' and birthdate < '1980-01-01'")
  end
  #with last names starting with "B", sorted by birthdate
  def self.last_names_starting_with_b
    return Customer.where("last like 'B%'").order(:birthdate)
  end
  #20 youngest customers, in any order (hint: lookup ActiveRecord `order` and `limit`)
  def self.twenty_youngest
    return Customer.order(birthdate: :desc).limit(20)
  end
  #the birthdate of Gussie Murray to February 8,2004 (HINT: lookup `Time.parse`)
  def self.update_gussie_murray_birthdate
    c1 = Customer.find_by(:first => 'Gussie')
    c1.birthdate = Time.parse("2004-02-08")
    c1.save
  end
  #all invalid emails to be blank
  def self.change_all_invalid_emails_to_blank
    #Customer.update_all(:email => '')
    Customer.all.each do |customer|
      customer.email = ''
      customer.save
    end
  end
  #database by deleting customer Meggie Herman
  def self.delete_meggie_herman
    c1 = Customer.find_by(:first => 'Meggie', :last => 'Herman')
    c1.delete
  end
  #database by deleting all customers born on or before 31 Dec 1977
  def self.delete_everyone_born_before_1978
    Customer.delete_all("birthdate <= '1977-12-31'")
  end
  
end
