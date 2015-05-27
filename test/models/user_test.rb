require 'test_helper'

class UserTest <ActiveSupport::TestCase
    def test_user
    	user1 = User.new(:id => users(:one).id,
    					:fullname => users(:one).fullname, 
               			:email => users(:one).email,
         				:encrypted_password => users(:one).encrypted_password,
    					:user_type => users(:one).user_type,
    					:adm_id => users(:one).adm_id)
    	
    	user2 = User.new(:id => users(:two).id,
    					:fullname => users(:two).fullname, 
               			:email => users(:two).email,
         				:encrypted_password => users(:two).encrypted_password,
    					:user_type => users(:two).user_type,
    					:adm_id => users(:two).adm_id)

    	user3 = User.new(:id => users(:three).id,
    					:fullname => users(:three).fullname, 
               			:email => users(:three).email,
         				:encrypted_password => users(:three).encrypted_password,
    					:user_type => users(:three).user_type,
    					:adm_id => users(:three).adm_id)

    	user4 = User.new(:id => users(:four).id,
    					:fullname => users(:four).fullname, 
               			:email => users(:four).email,
         				:encrypted_password => users(:four).encrypted_password,
    					:user_type => users(:four).user_type,
    					:adm_id => users(:four).adm_id)

       	msg = "usuario não foi salvo "
      	assert user1.save, msg
      	use_one_copy = User.find(user1.id)
      	assert_equal user1.fullname, user_one_copy.fullname

    end

    def test_should_be_invalid
	  	user = User.create
	  	assert !user, "User não deve ser criado"
	end

	def test_if_destroy
		userDestroy =  User.find(4)
		userDestroy.destroy!
		assert !userDestroy.destroy, "Usuario nao foi deletado"
	end

	def test_if_update
		userUpdate = User.find(3)
		userUpdate.fullname = "outro"
		userUpdate.save!
		assert !userUpdate.save, "Usuario nao foi atualizado"
	end 

end
