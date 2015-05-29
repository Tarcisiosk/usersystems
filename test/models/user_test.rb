require 'test_helper'

class UserTest <ActiveSupport::TestCase
	def test_user_valid
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

		User.all.each do |user|
			assert user.valid?, "Usuario: #{user.fullname} não é valido"	
		end
	end

	def test_should_be_invalid
			user = User.create
			assert user, "User não deve ser criado"
	end

	def test_if_destroy
		userDestroy =  User.find(4)
		userDestroy.destroy!
		assert userDestroy.destroy, "Usuario nao foi deletado"
	end

	def test_if_update
		userUpdate = User.find(3)
		userUpdate.fullname = "outro"
		userUpdate.save!
		assert userUpdate.save, "Usuario nao foi atualizado"
	end 

	def test_adm_id
		User.all.each do |user|
			if user.user_type == 2
				assert user.adm_id != user.id, "Usuario nao está correto"
			else
				assert user.adm_id == user.id, "Usuario nao está correto"
			end
		end
	end

	def test_uniqueness
		User.all.each  do |user|
			User.all.each do |userCompare|
				if user != userCompare
					assert user.email != userCompare.email, "Usuarios com emails iguais"
				end
			end
		end
	end

	def test_presence
		User.all.each do |user|
			assert user.fullname.present?, "usuario #{user.id} sem nome"
			assert user.email.present?, "usuario #{user.id} sem email"
		end
	end
end
